#include "rwmake.ch"

User Function CR0018()

	SetPrvt("AINDEXSC6,CQUERY,CFILMARKB,CCADASTRO,AROTINA,BFILTRASC6")
	SetPrvt("NOPCA,AAREA,CWHERE,CALIAS,LQUERY,NRESID")
	SetPrvt("CPEDIDO,NREGSC6,NREGSC5,AAREASC6,AAREASC5,AAREASB2")
	SetPrvt("AAREASA1,CQRY,NQTDLIBSC9,LRESIDUO,LPV,LBLOQUEADO")

	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Define Variaveis                                         �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

	aIndexSC6	:= {}
	cQuery	    := ""
	cFilMarkb   := ""
	//bFiltraSC6
	cCadastro := OemToAnsi("Elimina뇙o de Res죆uos")

	PRIVATE aRotina := {	{ "Pesquisar" ,"MA500Pesq" , 0 , 0},;
	{ "Processa" ,"U_ELIMRES()", 0 , 0}}

	If ( Pergunte("CR0018",.T.) )

		If MV_PAR15 == 1
			_cPed := "N"
		ElseIf MV_PAR15 == 2
			_cPed := "A"
		ElseIf MV_PAR15 == 3
			_cPed := "Z"
		ElseIf MV_PAR15 == 4
			_cPed := "D"
		Else
			_cPed := " /3/D/N/A/Z"
		Endif

		cQuery		:= "C6_FILIAL='"+xFilial("SC6")+"' AND "
		cQuery		+= "C6_NUM>='"+MV_PAR04+"' AND "
		cQuery		+= "C6_NUM<='"+MV_PAR05+"' AND "
		cQuery		+= "C6_PRODUTO>='"+MV_PAR07+"' AND "
		cQuery		+= "C6_PRODUTO<='"+MV_PAR08+"' AND "
		cQuery		+= "C6_CLI>='"+MV_PAR10+"' AND "
		cQuery		+= "C6_CLI<='"+MV_PAR11+"' AND "
		cQuery		+= "C6_LOJA>='"+MV_PAR12+"' AND "
		cQuery		+= "C6_LOJA<='"+MV_PAR13+"' AND "
		cQuery		+= "C6_ENTREG BETWEEN '"+Dtos(MV_PAR16)+"' AND '"+Dtos(MV_PAR17)+"' AND "
		cQuery		+= "C6_BLQ<>'R ' AND C6_BLQ<>'S ' AND "
		cQuery		+= "(C6_QTDVEN-C6_QTDENT)>0 AND "
		cQuery 		+= "C6_RESERVA='"+Space(Len(SC6->C6_RESERVA))+"'"

		cFilMarkb	:= "C6_FILIAL=='"+xFilial("SC6")+"'.And."
		cFilMarkb	+= "C6_NUM >= '"+MV_PAR04+"'.And."
		cFilMarkb	+= "C6_NUM <= '"+MV_PAR05+"'.And."
		cFilMarkb	+= "C6_PRODUTO >= '"+MV_PAR07+"'.And."
		cFilMarkb	+= "C6_PRODUTO <= '"+MV_PAR08+"'.And."
		cFilMarkb	+= "C6_CLI     >= '"+MV_PAR10+"'.And."
		cFilMarkb	+= "C6_CLI     <= '"+MV_PAR11+"'.And."
		cFilMarkb	+= "C6_LOJA    >= '"+MV_PAR12+"'.And."
		cFilMarkb	+= "C6_LOJA    <= '"+MV_PAR13+"'.And."
		cFilMarkb	+= "Dtos(C6_ENTREG)  >= '"+Dtos(MV_PAR16)+"' .And. "
		cFilMarkb	+= "Dtos(C6_ENTREG)  <= '"+Dtos(MV_PAR17)+"' .And. "
		cFilMarkb	+= "C6_BLQ<>'R '.And.C6_BLQ<>'S '.And."
		cFilMarkb	+= "(C6_QTDVEN-C6_QTDENT)>0.And."
		cFilMarkb	+= "C6_PEDAMOS $ '"+_cPed+"' .And."
		cFilMarkb	+= "C6_RESERVA=='"+Space(Len(SC6->C6_RESERVA))+"'"

		bFiltraSC6 := {|x| If(x==Nil,FilBrowse("SC6",@aIndexSC6,@cFilMarkb),If(x==1,cFilMarkb,cQuery)) }
		Eval(bFiltraSC6)

		MarkBrow("SC6","C6_OK",,,,GetMark())

		DbSelectArea("SC6")
		RetIndex("SC6")
		dbClearFilter()
		aEval(aIndexSC6,{|x| Ferase(x[1]+OrdBagExt())})
	EndIf
Return(.T.)

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑uncao    쿘a500Pesq � Autor 쿐duardo Riera          � Data �14.10.1999낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o 쿟ratamento do Filtro na Pesquisa da MarkBrowse              낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿝etorno   쿙enhum                                                      낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿛arametros쿙enhum                                                      낢�
굇�          �                                                            낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇�   DATA   � Programador   쿘anutencao Efetuada                         낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇�          �               �                                            낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/

Static Function Ma500Pesq()

	AxPesqui()

	Eval(bFiltraSC6)

Return(.T.)

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑uncao    쿘a500Resid� Autor 쿐duardo Riera          � Data �14.10.1999낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o 쿛rocessamento da Rotina de Eliminacao de Residuos.          낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿝etorno   쿙enhum                                                      낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿛arametros쿙enhum                                                      낢�
굇�          �                                                            낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇�   DATA   � Programador   쿘anutencao Efetuada                         낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇�          �               �                                            낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/

User Function ElimRes()

	Local nOpcA := 0
	FormBatch(OemToAnsi("Eliminacao de Residuos "),;
	{OemToAnsi("  Este programa  tem  como  objetivo  eliminar automaticamente os res죆uos    "),;
	OemToAnsi("  de pedidos de venda, baseado em informa뇯es da op뇯es de parametros.        ")},;
	{	{5,.F.,{|o| o:oWnd:End()}           },;
	{1,.T.,{|o| nOpcA:=1,o:oWnd:End()}  },;
	{2,.T.,{|o| o:oWnd:End() }}         })

	If ( nOpcA == 1 )
		Processa({|| Ma500Proc()},"Elimina뇙o de Res죆uos")
	EndIf
Return(.T.)

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑uncao    쿘a500Proc � Autor 쿐duardo Riera          � Data �14.10.1999낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o 쿛rocessamento da Rotina de Eliminacao de Residuos.          낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿝etorno   쿙enhum                                                      낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿛arametros쿙enhum                                                      낢�
굇�          �                                                            낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇�   DATA   � Programador   쿘anutencao Efetuada                         낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇�          �               �                                            낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/

Static Function Ma500Proc()

	Local aArea		:= GetArea()
	Local cQuery	:= ""
	Local cWhere	:= Eval(bFiltraSC6,2)
	Local cAlias	:= "SC6"
	Local lQuery	:= .F.
	Local nResid	:= 0
	Local cPedido   := ""
	Local nRegSC6	:= 0
	Local nRegSC5	:= 0

	dbSelectArea("SC6")
	dbSetOrder(1)
	Eval(bFiltraSC6)
	dbGotop()//IndRegua

	ProcRegua(SC6->(LastRec()))

	dbSelectArea(cAlias)

	While ( !Eof() .And. xFilial("SC6")==C6_FILIAL )
		If ( lQuery )
			nRegSC5 := REGSC5
			nRegSC6 := REGSC6
			SC6->(MsGoto(nREGSC6))
			SC5->(MsGoto(nREGSC5))
		Else
			SC6->(dbSkip())
			nRegSC6 := SC6->(RecNo())
			SC6->(dbSkip(-1))
			dbSelectArea("SC5")
			dbSetOrder(1)
			dbSeek(xFilial("SC5")+SC6->C6_NUM)
		EndIf
		If ( SC6->(IsMark("C6_OK",ThisMark(),ThisInv())) )
			If ( SC5->C5_EMISSAO>= MV_PAR02 .And. SC5->C5_EMISSAO<= MV_PAR03 )
				If ( (SC6->C6_QTDEMP == 0 .Or. MV_PAR09 == 1) .And. ;
				Empty(SC6->C6_RESERVA) .And. !SC6->C6_BLQ$"R #S " )
					If ( SC6->C6_QTDVEN > 0 )
						nResid := 100 - ( (SC6->C6_QTDENT+SC6->C6_QTDEMP) / SC6->C6_QTDVEN * 100 )
						nResid := NoRound(nResid,2)
					Else
						nResid := If(!Empty(SC5->C5_NOTA),0,100)
					EndIf

					If ( nResid <= MV_PAR01  )
						MaResDoFat(,MV_PAR09==1,.F.)
					EndIf
				EndIf
			EndIf
		EndIf
		dbSelectArea(cAlias)
		cPedido := C6_NUM
		IncProc("Eliminando Residuo: "+C6_NUM+"/"+C6_ITEM)
		If ( lQuery )
			dbSkip()
		Else
			dbGoto(nRegSc6)
		EndIf
		If ( cPedido != C6_NUM )
			SC6->(MaLiberOk({ cPedido },.T.))
		EndIf
	EndDo
	If ( lQuery )
		dbSelectArea(cAlias)
		dbCloseArea()
		dbSelectArea("SC9")
	EndIf
	RestArea(aArea)
Return(.T.)

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑uncao    쿘aResDoFat� Autor 쿐duardo Riera          � Data �15.10.1999낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o 쿑uncao de Eliminacao de Residuo por item de Pedido          낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿝etorno   쿙enhum                                                      낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿛arametros쿐xpN1: Numero do Registro do SC6                            낢�
굇�          쿐xpL2: Estorna Itens Bloqueados                             낢�
굇�          쿐xpL3: Avalia o Cabecalho do Pedido                         낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇�   DATA   � Programador   쿘anutencao Efetuada                         낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇�          �               �                                            낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/

Static Function MaResDoFat(nRegSc6,lBloqueado,lPV)

	Local aArea		:= GetArea()
	Local aAreaSC6  := SC6->(GetArea())
	Local aAreaSC5  := SC5->(GetArea())
	Local aAreaSB2  := SB2->(GetArea())
	Local aAreaSA1  := SA1->(GetArea())
	Local cQry		:= ""
	Local cQuery	:= ""
	Local nQtdLibSC9:= 0
	Local lResiduo  := .F.

	lPv			:= If(lPv==Nil,.T.,lPv)
	lBloqueado	:= If(lBloqueado==Nil,.T.,lBloqueado)

	dbSelectArea("SC6")
	If ( nRegSc6 != Nil )
		MsGoto(nRegSC6)
	EndIf

	dbSelectArea("SC5")
	dbSetOrder(1)
	MsSeek(xFilial("SC5")+SC6->C6_NUM)

	If ( Empty(SC6->C6_RESERVA) .And. !SC6->C6_BLQ$'R #S ' .And. ( SC6->C6_QTDEMP==0 .Or. lBloqueados ) )
		If ( lBloqueados )

			dbSelectArea("SC9")
			dbSetOrder(1)
			MsSeek(xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM)

			While ( !Eof() .And.SC9->C9_FILIAL == xFilial("SC9") .And.;
			SC9->C9_PEDIDO == SC6->C6_NUM .And.;
			SC9->C9_ITEM == SC6->C6_ITEM )
				If ( SC9->C9_BLCRED != '10' .And. SC9->C9_BLEST != '10' .And.;
				(SC9->C9_BLCRED != '  ' .OR. SC9->C9_BLEST != '  ') .And.;
				SC9->C9_PRODUTO == SC6->C6_PRODUTO )
					nQtdLibSC9 += SC9->C9_QTDLIB
				EndIf
				dbSelectArea("SC9")
				dbSkip()
			EndDo
			If ( nQtdLibSC9 == SC6->C6_QTDEMP )

				cQry := "SC9"
				dbSelectArea("SC9")
				dbSetOrder(1)
				MsSeek(xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM)

				dbSelectArea(cQry)

				While ( !Eof() .And.C9_FILIAL == xFilial("SC9") .And.;
				C9_PEDIDO == SC6->C6_NUM .And.;
				C9_ITEM == SC6->C6_ITEM)
					If ( C9_BLCRED != '10' .And. C9_BLEST != '10' .And.;
					(C9_BLCRED != '  ' .Or. C9_BLEST != '  ') .And.;
					SC9->C9_PRODUTO == SC6->C6_PRODUTO)
						If ( cQry!="SC9" )
							SC9->(MsGoto(RECNOSC9))
						EndIf
						SC9->(A460Estorna())
					EndIf
					dbSelectArea(cQry)
					dbSkip()
				EndDo
				If ( cQry != "SC9" )
					dbSelectArea(cQry)
					dbCloseArea()
					dbSelectArea("SC9")
				EndIf
			EndIf
		EndIf
		If ( SC6->C6_QTDEMP == 0 )
			dbSelectArea("SF4")
			dbSetOrder(1)
			MsSeek(xFilial("SF4")+SC6->C6_TES)
			If ( SF4->F4_ESTOQUE=="S" )
				dbSelectArea("SB2")
				dbSetOrder(1)
				MsSeek(xFilial("SB2")+SC6->C6_PRODUTO+SC6->C6_LOCAL)
				RecLock("SB2")
				SB2->B2_QPEDVEN -= Max(SC6->C6_QTDVEN-SC6->C6_QTDEMP-SC6->C6_QTDENT,0)
				SB2->B2_QPEDVE2 -= ConvUM(SB2->B2_COD, Max(SC6->C6_QTDVEN-SC6->C6_QTDEMP-SC6->C6_QTDENT,0), 0, 2)
				If ( SC6->C6_OP$"01#03#05" )
					SB2->B2_QEMPN  -= SC6->C6_QTDVEN
					SB2->B2_QEMPN2 -= ConvUM(SB2->B2_COD, SC6->C6_QTDVEN, 0, 2)
				Endif
				MsUnLock()
			EndIf
			If ( SF4->F4_DUPLIC=="S" )
				dbSelectArea("SA1")
				dbSetOrder(1)
				MsSeek(xFilial("SA1")+SC6->C6_CLI+SC6->C6_LOJA)
				RecLock("SA1")
				SA1->A1_SALPED -= xMoeda(Max(SC6->C6_QTDVEN-SC6->C6_QTDEMP-SC6->C6_QTDENT,0)*SC6->C6_PRCVEN,SC5->C5_MOEDA,Val(GetMv("MV_MCUSTO")),SC5->C5_EMISSAO)
				MsUnLock()
			EndIf
			If SF4->F4_PODER3 == "N"
				RecLock("SC6")
				SC6->C6_BLQ := "R"
				SC6->C6_XDTELIM := MV_PAR14
				SC6->C6_IDENCAT := "CR0018"
				MsUnLock()
				lResiduo := .T.
			Endif
		EndIf
		If ( lPv )
			MaLiberOk({ SC5->C5_NUM } , .T. )
		EndIf
	EndIf

	RestArea(aAreaSC6)
	RestArea(aAreaSC5)
	RestArea(aAreaSB2)
	RestArea(aAreaSA1)
	RestArea(aArea)


Return(lResiduo)
