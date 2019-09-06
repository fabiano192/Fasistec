#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PROCLI     � Autor � Fabiano da Silva  � Data �  27/12/04   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo						                              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Sigafat                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function PROCLI


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
Private aOrd         := {"Por Prod.Pasy","Por Prod.Cliente"}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "P"
Private nomeprog     := "PROCLI" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := "PROCLI"
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "PROCLI" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString      := "SZ2"
Private lRodape		 :=.T.
dbSelectArea("SZ2")
dbSetOrder(1)


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

//���������������������������������������������������������������������Ŀ
//� Tratamento das ordens. A ordem selecionada pelo usuario esta contida�
//� na posicao 8 do array aReturn. E um numero que indica a opcao sele- �
//� cionada na mesma ordem em que foi definida no array aOrd. Portanto, �
//� basta selecionar a ordem do indice ideal para a ordem selecionada   �
//� pelo usuario, ou criar um indice temporario para uma que nao exista.�
//� Por exemplo:                                                        �
//�                                                                     �
//� nOrdem := aReturn[8]                                                �
//� If nOrdem < 5                                                       �
//�     dbSetOrder(nOrdem)                                              �
//� Else                                                                �
//�     cInd := CriaTrab(NIL,.F.)                                       �
//�     IndRegua(cString,cInd,"??_FILIAL+??_ESPEC",,,"Selec.Registros") �
//� Endif                                                               �
//�����������������������������������������������������������������������

//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������

//���������������������������������������������������������������������Ŀ
//� Posicionamento do primeiro registro e loop principal. Pode-se criar �
//� a logica da seguinte maneira: Posiciona-se na filial corrente e pro �
//� cessa enquanto a filial do registro for a filial corrente. Por exem �
//� plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    �
//�                                                                     �
//� dbSeek(xFilial(""))                                                   �
//� While !EOF() .And. xFilial("") == A1_FILIAL                           �
//�����������������������������������������������������������������������

//���������������������������������������������������������������������Ŀ
//� O tratamento dos parametros deve ser feito dentro da logica do seu  �
//� relatorio. Geralmente a chave principal e a filial (isto vale prin- �
//� cipalmente se o arquivo for um arquivo padrao). Posiciona-se o pri- �
//� meiro registro pela filial + pela chave secundaria (codigo por exem �
//� plo), e processa enquanto estes valores estiverem dentro dos parame �
//� tros definidos. Suponha por exemplo o uso de dois parametros:       �
//� mv_par01 -> Indica o codigo inicial a processar                     �
//� mv_par02 -> Indica o codigo final a processar                       �
//�                                                                     �
//� dbSeek(xFilial("")+mv_par01,.T.) // Posiciona no 1o.reg. satisfatorio �
//� While !EOF() .And. xFilial("") == A1_FILIAL .And. A1_COD <= mv_par02  �
//�                                                                     �
//� Assim o processamento ocorrera enquanto o codigo do registro posicio�
//� nado for menor ou igual ao parametro mv_par02, que indica o codigo  �
//� limite para o processamento. Caso existam outros parametros a serem �
//� checados, isto deve ser feito dentro da estrutura de la�o (WHILE):  �
//�                                                                     �
//� mv_par01 -> Indica o codigo inicial a processar                     �
//� mv_par02 -> Indica o codigo final a processar                       �
//� mv_par03 -> Considera qual estado?                                  �
//�                                                                     �
//� dbSeek(xFilial("")+mv_par01,.T.) // Posiciona no 1o.reg. satisfatorio �
//� While !EOF() .And. xFilial("") == A1_FILIAL .And. A1_COD <= mv_par02  �
//�                                                                     �
//�     If A1_EST <> mv_par03                                           �
//�         dbSkip()                                                    �
//�         Loop                                                        �
//�     Endif                                                           �
//�����������������������������������������������������������������������

//���������������������������������������������������������������������Ŀ
//� Note que o descrito acima deve ser tratado de acordo com as ordens  �
//� definidas. Para cada ordem, o indice muda. Portanto a condicao deve �
//� ser tratada de acordo com a ordem selecionada. Um modo de fazer isto�
//� pode ser como a seguir:                                             �
//�                                                                     �
//� nOrdem := aReturn[8]                                                �
//� If nOrdem == 1                                                      �
//�     dbSetOrder(1)                                                   �
//�     cCond := "A1_COD <= mv_par02"                                   �
//� ElseIf nOrdem == 2                                                  �
//�     dbSetOrder(2)                                                   �
//�     cCond := "A1_NOME <= mv_par02"                                  �
//� ElseIf nOrdem == 3                                                  �
//�     dbSetOrder(3)                                                   �
//�     cCond := "A1_CGC <= mv_par02"                                   �
//� Endif                                                               �
//�                                                                     �
//� dbSeek(xFilial("")+mv_par01,.T.)                                      �
//� While !EOF() .And. &cCond                                           �
//�                                                                     �
//�����������������������������������������������������������������������

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
Prod.Pasy       Prod.Cliente    Cliente   Loja             Preco     Data
999999999999999 999999999999999 999999    99   99999999999999999 99999999
0               16              32        42   47                65
*/


cabec1:= "Prod.Pasy       Prod.Cliente    Cliente   Loja             Preco     Data"
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
	
	
	//���������������������������������������������������������������������Ŀ
	//� Verifica o cancelamento pelo usuario...                             �
	//�����������������������������������������������������������������������
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//���������������������������������������������������������������������Ŀ
	//� Impressao do cabecalho do relatorio. . .                            �
	//�����������������������������������������������������������������������
	
	If nLin > 57 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	// Coloque aqui a logica da impressao do seu programa...
	// Utilize PSAY para saida na impressora. Por exemplo:
	// @nLin,00 PSAY SA1->A1_COD
	
	_dDataRef := SZ2->Z2_DTREF01
	_nValor   := SZ2->Z2_PRECO01
	For i := 2 to 12
		If &("SZ2->Z2_DTREF"+StrZero(i,2)) >= _dDataRef
			_dDataRef := &("SZ2->Z2_DTREF"+StrZero(i,2))
			_nValor   := &("SZ2->Z2_PRECO"+StrZero(i,2))
		Endif
	Next i
	
	@nLin,00 PSAY SZ2->Z2_PRODUTO
	@nLin,16 PSAY SZ2->Z2_CODCLI
	@nlin,32 PSAY SZ2->Z2_CLIENTE
	@nlin,42 PSAY SZ2->Z2_LOJA
	@nlin,47 PSAY _nValor           Picture TM(_nValor,17)
	@nlin,65 PSAY _dDataRef
	nLin := nLin + 1 // Avanca a linha de impressao
	
	dbSkip() // Avanca o ponteiro do registro no arquivo
EndDo

//���������������������������������������������������������������������Ŀ
//� Finaliza a execucao do relatorio...                                 �
//�����������������������������������������������������������������������

IF lRodape
	roda(cbcont,cbtxt,tamanho)
Endif

SET DEVICE TO SCREEN

//���������������������������������������������������������������������Ŀ
//� Se impressao em disco, chama o gerenciador de impressao...          �
//�����������������������������������������������������������������������

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return
