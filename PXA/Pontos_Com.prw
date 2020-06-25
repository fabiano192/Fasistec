#Include "TOTVS.CH"
#include "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ºMT103IPC         ³                    º Data ³  02/12/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PONTO DE ENTRADA EXECUTADO APOS SELECIONAR O PEDIDO DE COM º±±
±±º          ³ PRAS (F5) NA TELA DO DOCUMENTO DE ENTRADA (MATA103)        º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT103IPC()

Local _nIt := PARAMIXB[1]   //no do item na acols
Local nD1_DESCRI:=0
Local nD1_COD:=0

_aAliOri := GetArea()
_aAliSC7 := SC7->(GetArea())

nD1_COD    := AScan(aHeader,{|x| AllTrim(x[2]) =="D1_COD"})
nD1_DESCRI := AScan(aHeader,{|x| AllTrim(x[2]) =="D1_YDESPRO"})
_nPPedido  := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "D1_PEDIDO" } )
_nPItemPc  := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "D1_ITEMPC" } )

_cPedido   := Acols[_nIt][_nPPedido]
_cItemPc   := Acols[_nIt][_nPItemPc]
_cDescri   := ""

SC7->(dbSetOrder(1))
If SC7->(dbSeek(xFilial("SC7")+_cPedido  + _cItemPc))
	_cDescri := SC7->C7_DESCRI
Endif

aCols[_nIt,nD1_DESCRI]:= _cDescri

RestArea(_aAliSC7)
RestArea(_aAliOri)

Return Nil
//-------------------------------------------------------------------------------------------------
User Function MT100LOK()

If cEmpAnt != "06"
	Return(.T.)
Endif

_aAliOri    := GetArea()
_aAliCTD    := CTD->(GetArea())
_aAliCTT    := CTT->(GetArea())
_aAliSF4    := SF4->(GetArea())

_lRet       := .T.
_nPCR       := aScan(aHeader,{|x| alltrim(x[2]) == "D1_CC"})
_nPITEMCTA  := aScan(aHeader,{|x| alltrim(x[2]) == "D1_ITEMCTA"})
_nPTES      := aScan(aHeader,{|x| alltrim(x[2]) == "D1_TES"})
_nPPEDIDO   := aScan(aHeader,{|x| alltrim(x[2]) == "D1_PEDIDO"})
_nPTIPO     := aScan(aHeader,{|x| alltrim(x[2]) == "D1_TIPO"})
_nPCFO      := aScan(aHeader,{|x| alltrim(x[2]) == "D1_CF"})
_nPValIPI   := aScan(aHeader,{|x| alltrim(x[2]) == "D1_VALIPI"})
_nPValICM   := aScan(aHeader,{|x| alltrim(x[2]) == "D1_VALICM"})

_cCFO       := ACOLS[n,_nPCFO]
_cCr        := ACOLS[n,_nPCR]
_cItemCta   := ACOLS[n,_nPITEMCTA]
_cTes       := ACOLS[n,_nPTES]
_cPedido    := ACOLS[n,_nPPEDIDO]
_cGrCtt     := _cGrCTD := Space(12)
_nValICM    := ACOLS[n,_nPVALICM]
_nValIPI    := ACOLS[n,_nPVALIPI]

If Empty(_cCr)
	_lRet := .F.
	MsgInfo("Favor Informar o Centro de Custo!!")
EndIf

If cTipo == "N"
	SF4->(dbSetOrder(1))
	If SF4->(dbSeek(xFilial("SF4")+_cTes))
		If SF4->F4_DUPLIC == "S" .And. SF4->F4_XPEDCOM <> "2"
			If Empty(_cPedido)
				MsgInfo("Favor Informar o Pedido de Compra!!")
				_lRet  := .F.
			Endif
		Endif
		
		If SF4->F4_ICM == "S" .And. _nValICM == 0
			MsgInfo("TES Incompativel com o Lancamento do ICMS!!")
			_lRet  := .F.
		Else
			If SF4->F4_ICM == "N" .And. _nValICM > 0
				MsgInfo("TES Incompativel com o Lancamento do ICMS!!")
				_lRet  := .F.
			Endif
		Endif
		
		If SF4->F4_IPI == "S" .And. _nValIPI == 0
			MsgInfo("TES Incompativel com o Lancamento do IPI!!")
			_lRet  := .F.
		Else
			If SF4->F4_IPI == "N" .And. _nValIPI > 0
				MsgInfo("TES Incompativel com o Lancamento do IPI!!")
				_lRet  := .F.
			Endif
		Endif
	Endif
Endif

_lDiv := .T.
If Alltrim(cEspecie) == "NFS"
	If Alltrim(_cCFO) <> "1933"
		_lDiv := .F.
	Endif
ElseIf Alltrim(cEspecie) == "CTR"
	If !Alltrim(_cCFO) $ "1352/1353"
		_lDiv := .F.
	Endif
ElseIf Alltrim(cEspecie) == "NFCEE"
	If !Alltrim(_cCFO) $ "1252/1253"
		_lDiv := .F.
	Endif
ElseIf Alltrim(cEspecie) == "NTSC /NFSC "
	If !Alltrim(_cCFO) $ "1302/1303"
		_lDiv := .F.
	Endif
Endif

If !_lDiv
	MsgInfo("Especie Incompativel com o CFOP!!")
	_lRet := .F.
Endif

RestArea(_aAliCTD)
RestArea(_aAliCTT)
RestArea(_aAliSF4)
RestArea(_aAliOri)

Return(_lRet)
//-------------------------------------------------------------------------------------------------
User function MT100TOK()

_aAliOri := GetArea()
_aAliSF4 := SF4->(GetArea())

_nPTES      := aScan(aHeader,{|x| alltrim(x[2]) == "D1_TES"})
_cTes       := ACOLS[n,_nPTES]
lRet		:=.T.

SF4->(dbSetOrder(1))
If SF4->(dbSeek(xFilial("SF4")+_cTes))
	If SF4->F4_DUPLIC == "S"
		_cNaturez := MaFisRet(,"NF_NATUREZA")
		lRet:=.T.
		If Empty (Alltrim(_cNaturez))
			MSGSTOP("ATENCAO, NATUREZA DO TITULO NAO PREENCHIDA")
			lRet:=.F.
		Endif
	Endif
Endif

RestArea(_aAliSF4)
RestArea(_aAliORI)

Return(lRet)

//-------------------------------------------------------------------------------------------------
User function SF1100I()

Local _aAliOri := GetArea()
Local _aAliSE2 := SE2->(GetArea())

If Left(cEmpAnt,2) $ "06/15" .And. !Empty(SF1->F1_DUPL) .AND. SF1->F1_TIPO == "N"
	U_PXH028(.T.)
Endif

If SF1->F1_TIPO == "N" .And. Left(cEmpAnt,2) <> "14"
	HOLVENC()
Endif

U_PXH015(SF1->F1_DOC,SF1->F1_SERIE,SF1->F1_FORNECE,SF1->F1_LOJA,1)

RestArea(_aAliSE2)
RestArea(_aAliOri)

Return
//-------------------------------------------------------------------------------------------------
Static Function HOLVENC()

Local _aALiOri := GetArea()
Local _aAliSE2 := SE2->(GetArea())

SE2->(dbSetOrder(6))
If SE2->(dbSeek(xFilial("SE2")+SF1->F1_FORNECE+ SF1->F1_LOJA + SF1->F1_PREFIXO + SF1->F1_DOC))
	
	_cChav    := SE2->E2_FILIAL + SE2->E2_FORNECE + SE2->E2_LOJA + SE2->E2_PREFIXO + SE2->E2_NUM
	_cNaturez := SE2->E2_NATUREZ
	
	While SE2->(!Eof()) .And.	_cChav == SE2->E2_FILIAL + SE2->E2_FORNECE + SE2->E2_LOJA + SE2->E2_PREFIXO + SE2->E2_NUM
		
		If (SE2->E2_VENCTO - DATE()) < Val(GETMV("MV_VENCDIA"))
			_dVencRea := DataValida(DATE() + Val(GETMV("MV_VENCDIA")))
			_dVencTo  := DATE() + Val(GETMV("MV_VENCDIA"))
		Else
			_dVencRea := SE2->E2_VENCREA
			_dVencTo  := SE2->E2_VENCTO
		Endif
		
		SE2->(RecLock("SE2",.F.))
		SE2->E2_VENCTO  := _dVencto
		SE2->E2_VENCREA := _dVencRea
		SE2->E2_DATALIB := dDataBase
		SE2->E2_USUALIB := cUsername
		SE2->E2_FILORIG := cFilAnt
		SE2->(MsUnlock())
		SE2->(dbSkip())
	EndDo
Endif

RestArea(_aAliSE2)
RestArea(_aAliOri)

Return

User Function Geracod

Local aArea:=GetArea()

SB1->(dbSetOrder(1))

_CODANT:= SB1->B1_COD
_XCOD  := SOMA1(LEFT(M->B1_SUBGRUP,3))+"001"
_COD   := SPACE(10)

SB1->(dbSeek(xFilial("SB1")+_XCOD,.T.))

SB1->(DBSKIP(-1))

IF TRIM(M->B1_GRUPO) == TRIM(SB1->B1_GRUPO) .AND. TRIM(M->B1_SUBGRUP) == TRIM(SB1->B1_SUBGRUP)
	_COD := SUBSTR(SB1->B1_GRUPO,1,1)
	_COD += SOMA1(SUBSTR(SB1->B1_COD,2,6))
ELSE
	_COD := SUBSTR(M->B1_SUBGRUP,1,4)+"0001"
ENDIF

RestArea(aArea)
//Return(  U_FnValidSB1(_Cod)   )
Return(  _Cod   )


User Function GeracodSub
Local aArea:=GetArea()

SetPrvt("_ALIAS,_ORDER,_RECNO,_CODANT,_XCOD,_COD")

_CODANT:= ZZG->ZZG_COD
_XCOD := SOMA1(LEFT(M->ZZG_GRUPO,4))+"0001"
_COD  := SPACE(07)


DBSELECTAREA("ZZG")
DBSETORDER(3)
DBSEEK(XFILIAL("ZZG")+_XCOD,.T.)

ZZG->(DBSKIP(-1))

IF TRIM(M->ZZG_GRUPO) == TRIM(ZZG->ZZG_GRUPO)
	_COD := SUBSTR(ZZG->ZZG_GRUPO,1,1)
	_COD += SOMA1(SUBSTR(ZZG->ZZG_COD,2,6))
ELSE
	_COD := TRIM(M->ZZG_GRUPO)+"001"
ENDIF

RestArea(aArea)

Return(  _Cod   )


User Function MT100GE2()

If SE2->(FieldPos("E2_CC")) > 0
	_aAliOri := GetArea()
	_aAliSD1 := SD1->(GetArea())
	_aAliSE2 := SE2->(GetArea())
	
	SD1->(dbSetOrder(1))
	If SD1->(dbseek(xFilial("SD1")+SE2->E2_NUM + SE2->E2_PREFIXO + SE2->E2_FORNECE + SE2->E2_LOJA))
		_cChavSD1 := SD1->D1_FILIAL + SD1->D1_DOC + SD1->D1_SERIE +  SD1->D1_FORNECE + SD1->D1_LOJA
		
		_cCusto := ""
		
		While SD1->(!Eof()) .And. _cChavSD1 == SD1->D1_FILIAL + SD1->D1_DOC + SD1->D1_SERIE +  SD1->D1_FORNECE + SD1->D1_LOJA
			
			_cCusto := SD1->D1_CC
			
			SD1->(dbSkip())
		EndDo
		
		SE2->(RecLock("SE2",.F.))
		SE2->E2_CC := _cCusto
		SE2->(MsUnLock())
	Endif
	
	RestArea(_aAliSD1)
	RestArea(_aAliSE2)
	RestArea(_aAliOri)
Endif

Return

User Function SF1100E()

_aAliOri := GetArea()
_aAliSZQ := SZQ->(GetArea())

If !Empty(SF1->F1_DTLANC)
	MsgBox("Atencao, o periodo ja foi fechado pelo Fiscal. Contactar Contabilidade","Atencao","ALERT")
	Return (.f.)
endif

If SF1->F1_TIPO = "N"
	_cQ := " DELETE FROM "+RetSqlName("SZQ")+" WHERE D_E_L_E_T_ = '' "
	_cq += " AND ZQ_PREFIXO = '"+SF1->F1_SERIE+" ' AND ZQ_NUM = '"+SF1->F1_DOC+" ' AND ZQ_FORNECE = '"+SF1->F1_FORNECE+" ' "
	_cq += " AND ZQ_LOJA    = '"+SF1->F1_LOJA +" ' AND ZQ_CODEMP = '"+cEmpAnt+Left(cFilAnt,3)+"'   AND ZQ_CODFIL  = '"+Right(cFilAnt,2)+" ' "
	
	TcSqlExec(_cQ)
EndIf

RestArea(_aAliSZQ)
RestArea(_aAliORI)

Return(.t.)



User Function WFW120P()

//If cEmpAnt = "16"
	_aAliOri  := GetArea()
	_aAliSA2  := SA2->(GetArea())
	_aAliSC7  := SC7->(GetArea())
	_aAliSCR  := SCR->(GetArea())
	
	_lRet   := .F.
	Private _cNivel := "01"
	oProcess := ""
	_lPedido := .T.
	
	U_PXH069( oProcess,_lRet,_cNivel,_lPedido )
	
	RestArea(_aAliSA2)
	RestArea(_aAliSC7)
	RestArea(_aAliSCR)
	RestArea(_aAliOri)
//Endif

Return




/*
Ponto de Entrada: MT120TEL  
Autor			: Fabiano da Silva
Data			: 17/06/15
Uso				: Inclusão de Campos no Pedido de Compras
Link TDN		: http://tdn.totvs.com/display/public/mp/MT120TEL
Descrição TDN	: LOCALIZAÇÃO : Function A120PEDIDO - Função do Pedido de Compras responsavel pela inclusão, alteração, exclusão e cópia dos PCs. EM QUE PONTO : Se encontra dentro da rotina que monta a dialog do pedido de compras antes  da montagem dos folders e da chamada da getdados.			
*/
User Function MT120TEL()

	Local aArea 		:= GetArea()

	Local oNewDialog 	:= PARAMIXB[1]
	Local aPosGet 		:= PARAMIXB[2]
	Local aObj 			:= PARAMIXB[3]
	Local nOpcx 		:= PARAMIXB[4]

	//If cEmpAnt = "16"
		Public _cYSolic	    := If(nOpcx == 3, Space(06) ,  SC7->C7_YSOLICI)
		Public _cYNome		:= If(!Empty(_cYSolic),Posicione("SZJ",1,xFilial("SZJ")+_cYSolic,'ZJ_NOME'),Space(50))
		Public _oYNome

		_lWhen := .T.

		@ 044,aPosGet[1,1] SAY "Solicitante:"								OF oNewDialog PIXEL SIZE 040,006
		@ 043,aPosGet[1,2] MSGET _cYSolic When .T. F3 "SZJ"	VALID NomUsu()	OF oNewDialog PIXEL SIZE 040,006
		@ 043,aPosGet[1,3] MSGET _oYNome VAR _cYNome  When .F.				OF oNewDialog PIXEL SIZE 120,006
	//Endif
	
	RestArea( aArea )

Return Nil


Static Function NomUsu()

	_lRet := .T.
	If !Empty(_cYSolic)
		SZJ->(dbSetOrder(1))
		If !SZJ->(msSeek(xFilial("SZJ")+_cYSolic))
			MsgAlert("Solicitante não encontrado!")
			_lRet := .F.
		Else
			_cYNome := SZJ->ZJ_NOME
			_oYNome:Refresh()
		Endif
	Endif

Return(_lRet)


/*
Ponto de Entrada: MTA120G2  
Autor			: Fabiano da Silva
Data			: 17/06/15
Uso				: Gravar os campos do ponto de Entrada MT120TEL
Link TDN		: http://tdn.totvs.com/pages/releaseview.action?pageId=6085572
Descrição TDN	: LOCALIZAÇÃO : Function A120GRAVA - Função responsável pela gravação do Pedido de Compras e Autorização de Entrega. EM QUE PONTO : Na função A120GRAVA executado após a gravação de cada item do pedido de compras recebe como parametro o Array manipulado pelo ponto de entrada MTA120G1 e pode ser usado para gravar as informações deste array no item do pedido posicionado.			
*/ 
User Function MTA120G2()

	Local aArea := GetArea()
	
	//If cEmpAnt = "16"
		SC7->C7_YSOLICI  	:= _cYSolic
	//Endif

	RestArea( aArea )

Return

User Function MT097END()

_aAliOri := GetArea()
_aAliSC7 := SC7->(GetArea())
_aAliSCR := SCR->(GetArea())

_lRet   := .F.

//MSGINFO("Ponto de Entrada MT097END!!")

Private _cNivel := "01"
oProcess := ""
_lPedido := .F.

U_PXH069( oProcess,_lRet,_cNivel,_lPedido )

RestArea(_aAliSC7)
RestArea(_aAliSCR)
RestArea(_aAliOri)

Return