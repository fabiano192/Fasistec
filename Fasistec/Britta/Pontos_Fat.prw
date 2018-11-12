#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

#define DS_MODALFRAME   128

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PONTOS   ³ Autor ³ Alexandro da Silva    ³ Data ³ 07/08/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ponto de Entrada no Faturamento                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Faturas a Pagar                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function SF2520E()

	_aAliOri := GETAREA()
	_aAliSF2 := SF2->(GETAREA())
	_aAliSD2 := SD2->(GETAREA())

	_cMotivo := Space(100)

	DEFINE MsDialog oDlg From 150,001 To 270,450 Title OemToAnsi("Motivo do Cancelamento") Pixel Style DS_MODALFRAME // Cria Dialog sem o botão de Fecha

	@ 02,10 TO 040,220
	@ 10,18 SAY "Informar o Motivo: "     SIZE 160,7
	@ 18,18 GET _cMotivo         WHEN .T. Valid (!EMPTY(_cMotivo) .And. Len(alltrim(_cMotivo))> 20)    SIZE 180,7

	@ 45,188 BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())

	oDlg:lEscClose := .F.

	ACTIVATE MSDIALOG oDlg CENTERED

	SD2->(dbSetorder(3))
	If SD2->(dbSeek(xFilial("SD2")+ SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA))

		_cChavSD2 :=  SD2->D2_DOC + SD2->D2_SERIE + SD2->D2_CLIENTE + SD2->D2_LOJA

		While SD2->(!Eof()) .And. _cChavSD2 ==  SD2->D2_DOC + SD2->D2_SERIE + SD2->D2_CLIENTE + SD2->D2_LOJA

			SZJ->(dbSetorder(1))
			If SZJ->(!dbSeek(xFilial("SZJ")+ SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA + SF2->F2_TIPO+SD2->D2_ITEM))
				SZJ->(RecLock("SZJ",.T.))
				SZJ->ZJ_FILIAL := xFilial("SZJ")
				SZJ->ZJ_DOC    := SF2->F2_DOC
				SZJ->ZJ_SERIE  := SF2->F2_SERIE
				SZJ->ZJ_CLIENTE:= SF2->F2_CLIENTE
				SZJ->ZJ_LOJA   := SF2->F2_LOJA
				SZJ->ZJ_TIPO   := SF2->F2_TIPO
				SZJ->ZJ_MOTIVO := _cMotivo
				SZJ->ZJ_DTCANC := Date()
				SZJ->ZJ_HORA   := Left(Time(),5)
				SZJ->ZJ_USUARIO:= Substr(cUsuario,7,15)
				SZJ->ZJ_DTEMIS := SF2->F2_EMISSAO
				SZJ->ZJ_HORAEMI:= SF2->F2_HORA
				SZJ->ZJ_VEND1  := SF2->F2_VEND1
				SZJ->ZJ_VALMERC:= SF2->F2_VALMERC
				SZJ->ZJ_VALBRUT:= SF2->F2_VALBRUT
				SZJ->ZJ_VALFRET:= SF2->F2_FRETE
				SZJ->ZJ_ITEM   := SD2->D2_ITEM
				SZJ->ZJ_PRODUTO:= SD2->D2_COD
				SZJ->ZJ_TES    := SD2->D2_TES
				SZJ->ZJ_PRCVEN := SD2->D2_PRCVEN
				SZJ->ZJ_QTDITEM:= SD2->D2_QUANT
				SZJ->ZJ_TOTITEM:= SD2->D2_TOTAL
				SZJ->ZJ_PEDIDO := SD2->D2_PEDIDO
				SZJ->(MsUnlock())
			Else
				SZJ->(RecLock("SZJ",.F.))
				SZJ->(dbDelete())
				SZJ->(MsUnlock())
			Endif

			SD2->(dbSkip())
		EndDo
	Endif

	RestArea(_aAliSD2)
	RestArea(_aAliSF2)
	RestArea(_aAliOri)

	U_GRLOG(Procname(),cModulo,__CUSERID,Ddatabase,Time(),cEmpAnt,cFilAnt)

Return



User Function M410ALOK()

	Local lRetorno := .T.

	If(SM0->M0_CODIGO $ "04/13/14/21/50")

		If(SC5->C5_ALTQTD == "S")
			MsgAlert("ATENCAO, NAO AUMENTAR A QUANTIDADE DO PEDIDO:"+Chr(13)+Chr(10)+SC5->C5_NUM+" - "+ALLTRIM(SC5->C5_NOMCLI))
		EndIf

	EndIf

	If ALTERA
		U_GRLOG(Procname(),cModulo,__CUSERID,Ddatabase,Time(),cEmpAnt,cFilAnt)
	EndIf

Return lRetorno
/*
User Function M460FRET()

_aAliOri := GetArea()
_aAliSC5 := SC5->(GetArea())
_aAliSC6 := SC6->(GetArea())
_aAliSC9 := SC9->(GetArea())

Alert("Ponto M460FRET!!")

_nRet 	 := 0

If SM0->M0_CODIGO + SM0->M0_CODFIL  $ "1306/1307" .And. SC5->C5_CLIENTE = "004903"
If SC5->C5_FRETE > 0
SC6->(dbsetOrder(1))
If SC6->(dbSeek(SC9->C9_FILIAL + SC9->C9_PEDIDO + SC9->C9_ITEM))
_nRet := SC9->C9_QTDLIB *  SC6->C6_VLRFRET
Endif
Endif
Endif

RestArea(_aAliSC5)
RestArea(_aAliSC6)
RestArea(_aAliSC9)
RestArea(_aAliOri)

Return(_nRet)

USER FUNCTION ChkC9Lib( cMarca, lInverte, cPedido, cMsg)

LOCAL aGArea:=GetArea()
LOCAL aQry:={}
LOCAL cQry:=""
LOCAL lRet:=.T.
LOCAL lChkPorc:=.F.
LOCAL lMark:=.F.

//CHK DO CAMPO PORCENTAGEM DE SERVIÇO
SX3->(OrdSetFocus(2))
lChkPorc:=(SX3->(DbSeek("C5_PDPERCS")) .AND. X3Uso(SX3->X3_USADO))

cQry:="SELECT A.C6_FILIAL,A.C6_CLI,A.C6_LOJA,A.C6_NUM, A.C6_ITEM, A.C6_PRODUTO, C.B1_DESC, B.C9_SEQUEN, A.C6_QTDVEN , A.C6_QTDENT, "+CRLF
cQry+="(SELECT SUM(C9_QTDLIB) QTENT FROM "+RetSqlName("SC9")+" BB WHERE BB.D_E_L_E_T_='' AND A.C6_FILIAL=BB.C9_FILIAL AND A.C6_CLI=BB.C9_CLIENTE AND A.C6_LOJA=BB.C9_LOJA AND A.C6_NUM=BB.C9_PEDIDO AND A.C6_PRODUTO=BB.C9_PRODUTO AND A.C6_ITEM=BB.C9_ITEM AND BB.C9_NFISCAL='' ) AS C9_QTDLIB, "+CRLF
cQry+="CASE WHEN B.C9_OK IS NOT NULL THEN B.C9_OK ELSE 'NULL' END C9_OK, B.C9_DATALIB, "+CRLF
cQry+=IIf( lChkPorc, "D.C5_PDPERCS","0")+" AS C5_PDPERCS "+CRLF
cQry+="FROM "+RetSqlName("SC6")+" A "+CRLF
cQry+="LEFT JOIN "+RetSqlName("SC9")+" B ON B.D_E_L_E_T_='' AND A.C6_FILIAL=B.C9_FILIAL AND A.C6_CLI=B.C9_CLIENTE AND A.C6_LOJA=B.C9_LOJA AND A.C6_NUM=B.C9_PEDIDO AND A.C6_PRODUTO=B.C9_PRODUTO AND A.C6_ITEM=B.C9_ITEM AND B.C9_NFISCAL='' "+CRLF
cQry+="INNER JOIN "+RetSqlName("SB1")+" C ON C.D_E_L_E_T_='' AND A.C6_PRODUTO=C.B1_COD "+CRLF
cQry+="INNER JOIN "+RetSqlName("SC5")+" D ON D.D_E_L_E_T_='' AND A.C6_FILIAL=D.C5_FILIAL AND A.C6_CLI=D.C5_CLIENTE AND A.C6_LOJA=D.C5_LOJACLI AND A.C6_NUM=D.C5_NUM "+CRLF
cQry+="WHERE A.D_E_L_E_T_='' "+CRLF
cQry+="AND A.C6_FILIAL='"+xFilial("SC6")+"' "+CRLF
cQry+="AND A.C6_NUM = B.C9_PEDIDO "+CRLF
cQry+="AND A.C6_CLI = B.C9_CLIENTE AND A.C6_LOJA=B.C9_LOJA "+CRLF
cQry+="GROUP BY A.C6_FILIAL,A.C6_CLI,A.C6_LOJA,A.C6_NUM, A.C6_ITEM, A.C6_PRODUTO,C.B1_DESC, B.C9_SEQUEN, A.C6_QTDVEN, A.C6_QTDENT, B.C9_OK, B.C9_DATALIB "+CRLF
cQry+=IIf(lChkPorc,",D.C5_PDPERCS"+CRLF,"")
cQry+="ORDER BY 2,3,4"+CRLF

//SE ITEM ESTA MARCADO E FOR PRODUTO PROCURA O SERVIÇO NA C9, SE FOR SERVIÇO PROCURA O PRODUTO NA C9


IF Select("C9TMP") <>0
C9TMP->(DbCloseArea())
ENDIF
TCQUERY cQry NEW ALIAS "C9TMP"
DbSelectArea("C9TMP")

TcSetField("C9TMP","C9_DATALIB","D")
TcSetField("C9TMP","C9_QTDLIB" ,"N",15,4)

DO WHILE .NOT. C9TMP->(Eof()) .AND. lRet

IF C9TMP->C9_OK <> "NULL"
lMark:=IsMark("C9_OK",cMarca,lInverte)

IF .NOT. lMark  .AND. C9TMP->C5_PDPERCS<>0
cMsg:="FALTOU SELECIONAR O ITEM: "+RTrim(C9TMP->C6_PRODUTO)+"-"+C9TMP->B1_DESC
lREt:=.F.
ELSEIF lMark .AND. (C9TMP->C6_QTDVEN - C9TMP->C6_QTDENT - C9TMP->C9_QTDLIB) < 0
cMsg:="QUANTIDADE A FATURAR É MAIOR QUE O SALDO DO PEDIDO."+CRLF+"SE POSSIVEL ALTERE O PEDIDO"
lRet:=.F.
ENDIF

ELSEIF C9TMP->C5_PDPERCS <> 0
cMsg:="FALTA LIBERAR O ITEM: "+CRLF+RTrim(C9TMP->C6_PRODUTO)+" - "+C9TMP->B1_DESC+CRLF+"VERIFIQUE O PEDIDO PARA CORRIGIR"
lRet:=.F.
ENDIF

C9TMP->(DbSkip())
ENDDO

C9TMP->(DbCloseArea())

RestArea(aGArea)

RETURN lREt


STATIC FUNCTION ChkOutroItem(cPed, cItem, cProd)
LOCAL cCodPro

cCodPro:=Iif( !("0SERVICO" $ cProd), "0SERVICO", cProd)
Posicione("SC9",1,xFilial("SC9")+cPed)  //C9_FILIAL, C9_PEDIDO, C9_ITEM, C9_SEQUEN, C9_PRODUTO, R_E_C_N_O_, D_E_L_E_T_

RETURN
*/



User Function M030EXC()

	Private lret := .T.,lachou

	_aAliOri := GetArea()
	_aAliSA1 := SA1->(GetArea())

	CTH->(dbSetOrder(1))
	If CTH->(dbSeek(xFilial("CTH")+"C"+SA1->A1_COD+SA1->A1_LOJA))
		CTH->(RecLock("CTH",.F.))
		CTH->(dbDelete())
		CTH->(MsUnLock())
	Endif

	U_GRLOG(Procname(),cModulo,__CUSERID,Ddatabase,Time(),cEmpAnt,cFilAnt)

	RestArea(_aAliSA1)
	RestArea(_aAliORI)

Return .T.



User Function A020DELE()

	_aAliORI := GetArea()
	_aAliCDH := CDH->(GetArea())
	_lRet    := .T.

	CTH->(dbSetOrder(1))
	If CTH->(dbSeek(xFilial("CTH")+"F"+SA2->A2_COD+SA2->A2_LOJA))
		CTH->(RecLock("CTH",.F.))
		CTH->(dbDelete())
		CTH->(MsUnLock())
	Endif

	U_GRLOG(Procname(),cModulo,__CUSERID,Ddatabase,Time(),cEmpAnt,cFilAnt)

	RestArea(_aAliCDH)
	RestArea(_aAliORI)

Return(_lRet)



User Function MA020TOK()

	Local lRet		:= .T.

	If !INCLUI
		Return(lRet)
	Endif

	_aAliORI := GetArea()
	_aAliSA2 := SA2->(GetArea())

	CTH->(dbSetOrder(1))
	If CTH->(!dbSeek(xFILIAL("CTH")+"F"+ M->A2_COD + M->A2_LOJA, .F.))
		CTH->(RecLock("CTH",.T.))
		CTH->CTH_FILIAL := xFILIAL("CTH")
		CTH->CTH_CLVL   := "F"+M->A2_COD + M->A2_LOJA
		CTH->CTH_CLASSE := "2"
		CTH->CTH_BLOQ   := "2"
		CTH->CTH_DESC01 := M->A2_NOME
		CTH->CTH_NORMAL := "0"
		MsUnlock()
	EndIf

	RestArea(_aAliSA2)
	RestArea(_aAliORI)

Return(lRet)



User Function MA030TOK()

	Local lRet		:= .T.

	_aAliOri := GetArea()
	_aAliSF4 := SF4->(GetArea())

	If !INCLUI
		Return(lRet)
	Endif

	_aAliORI := GetArea()
	_aAliSA1 := SA1->(GetArea())

	CTH->(dbSetOrder(1))
	If CTH->(!dbSeek(xFilial("CTH")+"C"+M->A1_COD+M->A1_LOJA, .F.))
		CTH->(RecLock("CTH",.T.))
		CTH->CTH_FILIAL := xFILIAL("CTH")
		CTH->CTH_CLVL   := "C"+M->A1_COD+M->A1_LOJA
		CTH->CTH_CLASSE := "2"
		CTH->CTH_BLOQ   := "2"
		CTH->CTH_DESC01 := M->A1_NOME
		CTH->CTH_NORMAL := "0"
		CTH->(MsUnlock())
	EndIf

	RestArea(_aAliSA1)
	RestArea(_aAliORI)

Return(lRet)



User function Msd2460()

	_aAliORI := GetArea()
	_aAliDA0 := DA0->(GetArea())
	_aAliDA1 := DA1->(GetArea())
	_aAliSA1 := SA1->(GetArea())
	_aAliSC5 := SC5->(GetArea())
	_aAliSC9 := SC9->(GetArea())
	_aAliSF4 := SF4->(GetArea())
	_aAliSZ2 := SZ2->(GetArea())
	_aAliSZA := SZA->(GetArea())

	SD2->D2_PDFRUM3:= Posicione("SA1",1,xfilial("SA1")+sd2->(d2_cliente+d2_loja),"a1_pdfrem3")
	SD2->D2_PDFRUTL:= Round(sd2->d2_pdfrUM3/posicione("SB1",1,xfilial("SB1")+sd2->d2_cod,"b1_conv"),2)

	If cEmpAnt+cFilAnt  $ "5001/5002"
		SD2->D2_PDFRETT:= SD2->D2_QUANT * SD2->D2_PDFRUM3
	Else
		SD2->D2_PDFRETT:= SD2->(D2_QUANT*D2_PDFRUTL)
	Endif

	SD2->D2_XOPESAI:= Posicione("SC5",1,xfilial("SC5")+sd2->d2_pedido,'c5_xopesai')

	If sc9->(c9_nfiscal+c9_serienf+c9_pedido+c9_item)==sd2->(d2_doc+d2_serie+d2_pedido+d2_itempv)
		If !empty(sc9->c9_pdoc)
			sza->(dbsetorder(1))
			If sza->(dbseek(xfilial()+sc9->c9_pdoc,.f.).and.reclock(alias(),.f.))
				sza->za_nota :=sd2->d2_doc
				sza->za_serie:=sd2->d2_serie
				sza->(msunlock())
				sd2->d2_pdoc:=sza->za_num
			Endif
		Endif
	Endif

	SZ2->(dbSetOrder(4))
	If SZ2->(dbSeek(SD2->D2_FILIAL + SD2->D2_CLIENTE + SD2->D2_LOJA + SD2->D2_COD))

		_nPreco := 	SZ2->Z2_PRCGER

		SD2->(RecLock("SD2",.F.))
		SD2->D2_YPRG := _nPreco
		SD2->(MsUnLock())
	Endif

	RestArea(_aAliDA0)
	RestArea(_aAliDA1)
	RestArea(_aAliSA1)
	RestArea(_aAliSC5)
	RestArea(_aAliSC9)
	RestArea(_aAliSF4)
	RestArea(_aAliSZ2)
	RestArea(_aAliSZA)
	RestArea(_aAliORI)

Return



//Ponto de Entrada para excluir os Itens da rotina de Liberação de Documentos.
User Function MA410DEL()

	Local _cCodBlq	:= '02'
	Local _cPedido	:= M->C5_NUM

	SCR->(dbSetOrder(1))
	If SCR->(dbSeek(xFilial("SCR")+ _cCodBlq + _cPedido ))

//		_cChavSCR := SCR->CR_TIPO + SCR->CR_NUM
		_cChavSCR := SCR->CR_TIPO + Left(SCR->CR_NUM,6)

		ZAH->(dbSetOrder(1))
		If ZAH->(dbSeek(SCR->CR_FILIAL + _cChavSCR  ))

			_cCq := " DELETE "+RetSqlName("ZAH")+ " WHERE ZAH_FILIAL = '"+SCR->CR_FILIAL+"' AND LEFT(ZAH_NUM,6) = '"+Left(SCR->CR_NUM,6)+"' AND ZAH_TIPO = '"+SCR->CR_TIPO+"' "
			TcSqlExec(_cCq)

		Endif

		While SCR->(!Eof())	.And. _cChavSCR == SCR->CR_TIPO + Left(SCR->CR_NUM,6)

			SCR->(RecLock("SCR",.F.))
			SCR->(dbDelete())
			SCR->(MsUnlock())

			SCR->(dbSkip())
		EndDo
	Endif

Return(Nil)

