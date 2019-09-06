#include "RWMAKE.CH"
#include "PROTHEUS.CH"
#include "shell.ch"
#include "FILEIO.CH"

/*
Programa	: CR0044
Autor		: Fabiano da Silva
Data		: 03/10/2013
Descrição	: Gerar etiqueta de embalagem para Caterpillar Exportação conforme Projeto SP20 (Standart Practice 20)
*/

User Function CR0044()

	LOCAL oDlg1 := NIL

	_cCOD    := SPACE(15)
	_cPedido := Space(8)
	_nQtEtiq := 00000
	_nQtPcEmb:= 00000
	_nQtPeca := 00000
	_cDescp  := ""
	_nQtdEmb := 0000

	PRIVATE oPrn       	:= NIL
	PRIVATE oFont2     	:= NIL
	PRIVATE oFont5     	:= NIL

	DEFINE FONT oFont2 NAME "Arial" SIZE 0,13 OF oPrn BOLD
	DEFINE FONT oFont5 NAME "Arial" SIZE 0,10 OF oPrn BOLD

	DEFINE MSDIALOG oDlg1 FROM 0,0 TO 290,390 TITLE "Etiquetas Clientes Exportaçao" OF oDlg1 PIXEL

	@ 10 ,10 SAY "Codigo:" OF oDlg1 PIXEL Size 150,010 FONT oFont2
	@ 10 ,70 GET _cCod     PICTURE "@!" SIZE 70,10 VALID VerProd() F3 "SB1" OBJECT OWCOD
	@ 30 ,10 GET _cDescP   SIZE 165,10 WHEN .F. OBJECT OWDESCP
	
	@ 50 ,10 SAY "Pedido de Venda + Item:" OF oDlg1 PIXEL Size 150,010 FONT oFont2
	@ 50 ,70 GET _cPedido  PICTURE "@!" SIZE 70,10 VALID VerProc()  OBJECT oPedido

	@ 70 ,10 SAY "Qtd. Copias:" OF oDlg1 PIXEL Size 150,010 FONT oFont2
	@ 70 ,70 GET _nQtEtiq   PICTURE "@E 99999" SIZE 50,10 VALID VERETI() OBJECT OWETI
	
	@ 90,030 BUTTON "OK" 		 SIZE 036,012 ACTION (Processa({|| ImpEt() }),oDlg1:End()) 	OF oDlg1 PIXEL
	@ 90,070 BUTTON "Sair"       SIZE 036,012 ACTION ( oDlg1:End()) 			OF oDlg1 PIXEL

	ACTIVATE MSDIALOG oDlg1 CENTERED

Return


Static Function VerProd()

	_lRet    :=.F.
	_cDescP  :=""

	DBSELECTAREA("SB1")
	DBSETORDER(1)
	IF DBSEEK(XFILIAL("SB1")+_cCod)
		_cDescP  := SB1->B1_DESC
		_lREt    := .T.
	Endif

	oWDESCP :Refresh()

Return(_lRet)


Static Function VerETI()

	_lRet    :=.t.

	If _nQtEtiq == 0
		_lRet := .F.
	Endif

Return(_lRet)


Static Function VerQTEM()

	_lRet    :=.t.

	If _nQtPcEmb == 0
		_lRet := .F.
	Endif

Return(_lRet)


Static Function VerQTEMB()

	_lRet    :=.t.

	If _nQtdEmb == 0
		_lRet := .F.
	Endif

Return(_lRet)


Static Function VerQTPC()

	_lRet    :=.t.

	If _nQTPECA == 0
		_lRet := .F.
	Endif

Return(_lRet)


Static Function VerProc()

	_lRet := .F.

	SC6->(dbSetOrder(1))
	IF SC6->(dbSeek(xFilial("SC6")+_cPedido+_cCod))

		dbSelectArea("EE8")
		dbOrderNickName("INDEE81")
		If dbSeek(xFilial("EE8") + LEFT(_cPedido,6)+Space(14)+Right(_cPedido,2) )

			dbSelectArea("EE9")
			dbSetOrder(1)
			If dbSeek(xFilial("EE9") + EE8->EE8_PEDIDO+EE8->EE8_SEQUEN )

				dbSelectArea("EEC")
				dbSetOrder(1)
				If dbSeek(xFilial("EEC") + EE9->EE9_PREEMB )

					If !Empty(EEC->EEC_EDIASN)
						_lRet := .T.
					Else
						MsgInfo('ASN não enviado, não será possível gerar as etiquetas')
					Endif
				Endif
			Endif
		Endif
	Endif

Return(_lRet)


Static Function ImpEt()

	DBSELECTAREA("SA1")
	DBSETORDER(1)
	DBSEEK(XFILIAL("SA1")+EEC->EEC_IMPORT+EEC->EEC_IMLOJA)

	DBSELECTAREA("SZ2")
	DBSETORDER(4)
	IF DBSEEK(XFILIAL("SZ2")+SC6->C6_CPROCLI+SC6->C6_CLI+SC6->C6_LOJA+SC6->C6_PRODUTO)

		If !Empty(SA1->A1_DTCODE) .Or. SC6->C6_CLI <> '000018'
		
			_cPais := ""
			dbSelectArea("SYA")
			dbSetOrder(1)
			If dbSeek(xFilial("SYA")+SA1->A1_PAIS)
				_cPais := Alltrim(SYA->YA_NOIDIOM)
			Endif

			SZ7->(dbSetOrder(3))
			If SZ7->(dbSeek(xFilial("SZ7") + EE9->EE9_PREEMB + EE9->EE9_SEQEMB))

				_cChave := SZ7->Z7_PREEMB+SZ7->Z7_SEQEMB

				//Imp()

				While SZ7->(!EOF()) .And. _cChave == SZ7->Z7_PREEMB+SZ7->Z7_SEQEMB

					For n:=1 to _nQtEtiq
						Imp()
					Next n

					SZ7->(dbskip())
				EndDo

			Endif

		Else
				
			MsgInfo("Campo DT Code não informado no cadastro de Produto X Cliente")

		Endif

	Endif

Return


Static Function IMP()

	LOCAL aParamImp		:= {}
	LOCAL _cDescr:=""

	aParamImp:={}

	AAdd(aParamImp, {Left(SA1->A1_NOME,32)     			,"[NOMECLI]"})   //Nome Cliente
	aADD(aParamImp, {SUBSTR(SA1->A1_END,1,31)        	,"[ENDCLI1]"})   //Endereço do Cliente 1
	aADD(aParamImp, {SUBSTR(SA1->A1_END,32,31)       	,"[ENDCLI2]"})   //Endereço do Cliente 2
	aADD(aParamImp, {Alltrim(SA1->A1_DTCODE)       		,"[DTCODE]"})    //DTCODE
	aADD(aParamImp, {"1L"+Alltrim(SA1->A1_DTCODE)       ,"[DTCODE2D]"})  //Código de Barras - DTCODE

	aADD(aParamImp, {Alltrim(SC6->C6_PRODUTO)      		,"[CODPASY]"})   //Código Produto Pasy
	aADD(aParamImp, {Alltrim(EE9->EE9_NF)      			,"[NF]"})   	 //Nota fiscal
	
	If !Empty(SZ2->Z2_PCCODE)
		AAdd(aParamImp, {SUBSTR(SZ2->Z2_PCCODE,1,40)		,"[CODCLI]"})    //Cod. Produto Cliente
		AAdd(aParamImp, {"P"+alltrim(SZ2->Z2_PCCODE)		,"[CODCLIBAR]"}) //Codigo de Barras - Cod. Produto Cliente
		AAdd(aParamImp, {"P"+alltrim(SZ2->Z2_PCCODE)		,"[CODCLI2D]"})  //Codigo de Barras - Cod. Produto Cliente
	Else
		AAdd(aParamImp, {SUBSTR(EE9->EE9_PART_N,1,40)		,"[CODCLI]"})    //Cod. Produto Cliente
		AAdd(aParamImp, {"P"+alltrim(EE9->EE9_PART_N)		,"[CODCLIBAR]"}) //Codigo de Barras - Cod. Produto Cliente
		AAdd(aParamImp, {"P"+alltrim(EE9->EE9_PART_N)		,"[CODCLI2D]"})  //Codigo de Barras - Cod. Produto Cliente
	Endif
	
	AAdd(aParamImp, {Alltrim(STR(EE9->EE9_QE))			,"[QUANT]"})    	//Quantidade
	AAdd(aParamImp, {"Q"+Alltrim(STR(EE9->EE9_QE))		,"[QUANTBAR]"}) 	//Codigo de Barras - Quantidade
	AAdd(aParamImp, {"Q"+Alltrim(STR(EE9->EE9_QE))		,"[QUANT2D]"}) 	//Codigo de Barras - Quantidade

	AAdd(aParamImp, {"4L"+"BR"							,"[ORI2D]"})    	//Código de Barras - Pais Origem

	AAdd(aParamImp, {SUBSTR(SZ2->Z2_REVISAO,1,40)		,"[EC]"})       	//Revisao
	AAdd(aParamImp, {"2P"+SUBSTR(SZ2->Z2_REVISAO,1,40)	,"[EC2D]"})    	//Código de Barras - Revisao

	AAdd(aParamImp, {alltrim(EE9->EE9_REFCLI)			,"[ORDER]"})    	//P.O.
	AAdd(aParamImp, {"K"+alltrim(EE9->EE9_REFCLI)		,"[ORDERBAR]"}) 	//Codigo de Barras - P.O.
	AAdd(aParamImp, {"K"+alltrim(EE9->EE9_REFCLI)		,"[ORDER2D]"}) 	//Codigo de Barras - P.O.
	
	_cEtiq := alltrim(SZ7->Z7_CODIGO)
	AAdd(aParamImp, {	_cEtiq							,"[ETIQ]"})    	//Número Etiqueta
	AAdd(aParamImp, {"3S"+_cEtiq						,"[ETIQBAR]"}) 	//Codigo de Barras - Número Etiqueta
	AAdd(aParamImp, {"3S"+_cEtiq						,"[ETIQ2D]"}) 	//Codigo de Barras - Número Etiqueta

	u_Etiqexp(aParamImp)

Return .T.



User FUNCTION Etiqexp(aInfo, nVias)

	LOCAL cEtiq:=""
	LOCAL cTemplate:=""
	LOCAL cArq:=""
	LOCAL cArqBat:=""
	LOCAL nSt:=""
	LOCAL cNVias
	LOCAL aDefs:={}
	LOCAL nHandle
	LOCAL nLength
	LOCAL nCpo:=1
	LOCAL cXXX:=""
	LOCAL nPosCpo:=0

	cNVias:=IIf(Valtype(nVias)=="N",StrZero(nVias,4,0), "0001")

	cTemplate:="\etiquetas\CR0044.prn"
	IF !File( (cTemplate) )
		Alert('Esta função procura o Template da Etiqueta "'+Upper(cTemplate)+'" no Servidor do Sistema.'+CRLF+'E este template não foi encontrado no local indicado.')
	RETURN
	ENDIF

	nHandle := Fopen( (cTemplate) , FO_READ + FO_SHARED )
	nLength := FSEEK(nHandle, 0, FS_END)

	FSEEK(nHandle, 0)

	nLidos:=FRead( nHandle, cEtiq, nLength )

	FClose(nHandle)
        
	If nLength <> nLidos
		Alert("Não foi possivel ler todo o Template da Etiqueta: '"+cTemplate+"'")
	RETURN
	ENDIF

	FOR ncpo:=1 TO Len(aInfo)
		nPosCpo:=AT((aInfo[nCpo,2]),cEtiq)
		IF nPoscpo <> 0
			cEtiq:=Stuff( cEtiq,  nPosCpo,  Len(aInfo[nCpo,2]), (Alltrim(aInfo[nCpo,1])))
		ENDIF
	NEXT

	cArq:=GetTempPath(.T.)+Criatrab(,.F.)
	MemoWrite( (cArq),cEtiq)

	cArqBat:=cArq+".bat"
	MemoWrite( (cArqBat), ("TYPE "+cArq+" >LPT1") )
	nSt:=WaitRun( (cArqBat),0)

	FERASE((cArq))
	FERASE( (cArqBat) )

RETURN

