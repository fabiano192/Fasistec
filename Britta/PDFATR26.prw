	#INCLUDE "PROTHEUS.CH"
	#INCLUDE "rwmake.ch"
	#INCLUDE "TOPCONN.CH"

	#DEFINE QTDE    1
	#DEFINE VLUNIT  2
	#DEFINE VLSERV  3
	#DEFINE VLFRETE 4
	#DEFINE VLBRUTO 5
	#DEFINE NROREGS 6

	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºPrograma  ³ PdFatR26 º Autor ³ MARCIO AFLITOS  º Data ³     08/11/10   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDescricao ³ RELATORIO DAS NOTAS POR CLIENTE/OBRA/PRODUTO               º±±
	±±º          ³ (COPIA ALTERADA DO PROG. PDFATR03)                         º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ AP6 IDE                                                    º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	ALTERAÇÕES:
	/*/

	User Function PDFATR26()

	cPerg            := "PFTR03"
	titulo           := "Faturamento por Cliente / Obra / Produto"
	cDesc1           := "Este programa irá emitir o Faturamento por Cliente / Obra / Produto"
	cDesc2           := "conforme os parametros informados."
	cDesc3           := "Especifico "+Trim(SM0->M0_NOMECOM)
	cString          := "SD2"
	Titulo           := "Faturamento por Cliente / Obra / Produto"
	aOrdem           := {"por Nro.NF","por Data Emissao"}
	aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	nLastKey         := 0
	cbtxt            := Space(10)
	CONTFL           := 01
	wnrel            := "PDFATR26" // Coloque aqui o nome do arquivo usado para impressao em disco
	imprime          := .T.
	lEnd             := lAbortPrint  := .F.
	limite           := 132
	m_pag            := 01
	Private titulo   := "Faturamento por Cliente / Obra / Produto"
	Private Cabec1   :=" CLIENTE / OBRA                  ------------N-O-T-A------------                                               VL.SERVICO                             PRECO UNIT."
	Private Cabec2   :=" PRODUTO                         NRO/Serie      EMISSAO    HORA   TES      QUANT     PR.UNIT.    VL.PRODUTO      USINAGEM     VL.FRETE     VL.TOTAL   MEDIO/FINAL    MOTORISTA"
	Private Li       := 99
	Private nomeprog := "PDFATR26" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo    := 15
	Private tamanho  := "G"


	PRIVATE aOpeSai:={{"01","MSP"},{"02","MRE"}}

	_cPicD2_QUANT    := "@E 99,999.99"   //PesqPict("SD2","D2_QUANT")
	_cPicD2_PRCVEN   := "@E 99,999.99"   //PesqPict("SD2","D2_PRCVEN")
	_cPicF2_VALMERC  := "@ZE 999,999.99"    //PesqPict("SF2","F2_VALMERC")
	_cPicF2_FRETE    := "@ZE 99,999.99"     //PesqPict("SF2","F2_FRETE")
	_cPicF2_VALBRUT  := "@E 9999,999.99"   // PesqPict("SF2","F2_VALBRUT")

	// Verifica as perguntas selecionadas
	validperg(cPerg)
	pergunte(cPerg,.F.)

	//Envia controle para a funcao SETPRINT.
	wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrdem,.T.,tamanho)

	If LastKey() == 27 .Or. nLastKey == 27
		Return
	Endif
	SetDefault(aReturn,cString)
	If nLastKey == 27
		Return
	Endif

	cFilterUser:=aReturn[7]

	MSAGUARDE({||PDFATR26_Consulta()} ,"Montando Informacoes ....")

	DbSelectArea("TMP")

	RptStatus({|lAbortPrint| PDFATR26_Imprime(Cabec1,Cabec2,Titulo,Li) },Titulo)

	tmp->(DbCloseArea())

	Return


	Static Function PDFATR26_Imprime(Cabec1,Cabec2,Titulo,Li)

	LOCAL bPrUnit
	LOCAL cFilterUser:=aReturn[7]

	bPrUnit:={|vrtot,qtd| Round(vrtot / qtd, 2) }
	CbTxt         := ""
	cbcont        := 0
	If cEmpAnt == "04"
		Titulo+=Iif( Type("MV_PAR07")=="N", "  >>>Operações de Saida: "+aOpeSai[MV_PAR07,1]+"-"+aOpeSai[MV_PAR07,2]+" >>>", "")
	Endif
	Titulo+=" de "+DTOC(MV_PAR01)+" a "+DTOC(MV_PAR02)
	DbSelectArea("SA1")
	DbSetOrder(1)
	DbSelectArea("TMP")
	SetRegua(RecCount())
	DbGoTop()

	_aTotGer := {0,0,0,0,0,0}  //qt merc,val merc,qt serv,val serv,frete,total Geral

	If Li >59
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		Li := 9
	Endif

	While !EOF() .AND. !lAbortPrint
		
		If !Empty(cFilterUser).and.!(&cFilterUser)
			dbSkip()
			Loop
		Endif
		
		If Li >59
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			Li := _Prow()+1
		Endif
		
		DbSelectArea("SA1")
		DbSeek(xFilial("SA1")+TMP->F2_CLIENTE+TMP->F2_LOJA)
		DbSelectArea("TMP")
		
		@ Li,001 Psay TMP->F2_CLIENTE+"/"+TMP->F2_LOJA+" - "+TRIM(SA1->A1_NOME)
		Li+=2
		
		_cCliente := TMP->F2_CLIENTE+TMP->F2_LOJA
		_aTotCli   := {0,0,0,0,0,0}  //qtmerc,valmerc,qt serv,val serv,frete,total do cliente
		
		While !EOF() .and. TMP->F2_CLIENTE+TMP->F2_LOJA==_cCliente  .AND. !lAbortPrint
			
			If !Empty(cFilterUser).and.!(&cFilterUser)
				dbSkip()
				Loop
			Endif
			
			If Li >59
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				Li := _prow()+1
			Endif
			
			@ Li,001 Psay PadR(Alltrim("Obra "+TMP->(C5_CODEE+" - "+c5_descee)),220,"-")
			Li+=2
			
			If Li >59
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				Li := _prow()+1
			Endif
			
			_cObra     := TMP->C5_CODEE
			_aTotObra  := {0,0,0,0,0,0}  //quant merc,val merc, quant serv, val serv,frete,total do cliente+loja (obra)
			
			While !EOF() .and. TMP->F2_CLIENTE+TMP->F2_LOJA+TMP->C5_CODEE==_cCliente+_cObra  .AND. !lAbortPrint
				
				If !Empty(cFilterUser).and.!(&cFilterUser)
					dbSkip()
					Loop
				Endif
				
				If Li >59
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
					Li := _prow()+1
				Endif
				
				_cProd      := TMP->D2_COD
				_aTotProd   := {0,0,0,0,0,0}
				
				@ Li,001 Psay PadR(TRIM(TMP->D2_COD)+" - "+Alltrim(Posicione("SB1",1,xFilial("SB1")+TMP->D2_COD,"B1_DESC")),30)
				
				While !EOF() .and. TMP->F2_CLIENTE+TMP->F2_LOJA+TMP->C5_CODEE+TMP->D2_COD==_cCliente+_cObra+_cProd  .AND. !lAbortPrint
					
					If !Empty(cFilterUser).and.!(&cFilterUser)
						dbSkip()
						Loop
					Endif
					
					If Li >59
						Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
						Li := _prow()+1
						@ Li,001 Psay PadR(TRIM(TMP->D2_COD)+" - "+Alltrim(Posicione("SB1",1,xFilial("SB1")+TMP->D2_COD,"B1_DESC")),30)
					Endif
					
					IncRegua()        
					_cVendedor:=tmp->(f2_vend1+" "+Left(Posicione("SA3",1,xFilial("SA3")+F2_VEND1,"A3_NOME"),40))
					If 	tmp->(d2_qtdedev > 0)
						_cVendedor:= "NOTA FISCAL DEVOLVIDA"
					Elseif empty(tmp->f2_vend1)	
						_cVendedor:=space(len(_cVendedor))
					endif
					_nTotLin:=Tmp->(ValItMerc+ValItServ+VALFRETE)
					@ Li,033 Psay Alltrim(TMP->F2_DOC)
					@ Li,043 Psay TMP->D2_SERIE
					@ Li,048 Psay DTOC(F2_EMISSAO)
					@ Li,059 Psay TMP->F2_HORA
					@ Li,066 Psay TMP->D2_TES
					@ Li,071 Psay tran(QTITMERC,_cPicD2_QUANT)
					@ Li,084 Psay tran(D2_PRCVEN,_cPicD2_PRCVEN)
					@ Li,096 Psay tran(VALITMERC,_cPicF2_VALMERC)
					@ Li,111 Psay tran(VALITSERV,_cPicF2_FRETE)
					@ Li,124 Psay Tran(VALFRETE,_cPicF2_FRETE)
					@ Li,136 Psay Tran(_nTotLin,_cPicF2_VALBRUT)
					@ Li,152 Psay tran( Eval(bPrUnit,_nTotLin,QTITMERC),_cPicD2_PRCVEN)
					If TMP->ORIGEM == "C"
						@ Li,164 Psay "NOTA FISCAL CANCELADA"
					Else
						@ Li,164 Psay _cVendedor
						//Acumula os totais por produto
						_aTotProd[QTDE]   += TMP->QTITMERC
						_aTotProd[VLUNIT] += TMP->VALITMERC
						_aTotProd[VLSERV] += TMP->VALITSERV
						_aTotProd[VLFRETE]+= TMP->VALFRETE
						_aTotProd[VLBRUTO]+= _nTotLin
						_aTotProd[NROREGS]+= 1
					Endif
					Li++
					
					
					DbSelectArea("TMP")
					DbSkip()
				EndDo
				
				If Li >59
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
					Li := 9
				Endif
				
				@ Li,033 Psay padr(Alltrim("Total Produto "+LEFT(_cProd,4)),25,".")
				@ Li,071 Psay tran(_aTotProd[QTDE]   ,_cPicD2_QUANT)
				@ Li,096 Psay tran(_aTotProd[VLUNIT] ,_cPicF2_VALMERC)
				@ Li,110 Psay tran(_aTotProd[VLSERV] ,_cPicF2_VALBRUT)
				@ Li,124 Psay tran(_aTotProd[VLFRETE],_cPicF2_FRETE)
				@ Li,136 Psay tran(_aTotProd[VLBRUTO],_cPicF2_VALBRUT)
				@ Li,152 Psay tran( Eval(bPrUnit, _aTotProd[VLBRUTO], _aTotProd[QTDE]), _cPicD2_PRCVEN)
				Li+=2
				
				//Acumula os totais da obra
				AEval( _aTotProd, {|nn,i| _aTotObra[i]:=_aTotObra[i] + nn})
			EndDo
			
			If Li >59
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				Li := 9
			Endif
			
			@ Li,033 Psay padr(AllTrim("Total Obra "+_cObra),25,".")
			@ Li,071 Psay tran(_aTotObra[QTDE]   ,_cPicD2_QUANT)
			@ Li,096 Psay tran(_aTotObra[VLUNIT] ,_cPicF2_VALMERC)
			@ Li,110 Psay tran(_aTotObra[VLSERV] ,_cPicF2_VALBRUT)
			@ Li,124 Psay tran(_aTotObra[VLFRETE],_cPicF2_FRETE)
			@ Li,136 Psay tran(_aTotObra[VLBRUTO],_cPicF2_VALBRUT)
			@ Li,152 Psay tran( Eval(bPrUnit, _aTotObra[VLBRUTO], _aTotObra[QTDE]), _cPicD2_PRCVEN)
			
			Li+=2
			
			//Acumula os total por cliente
			AEval( _aTotObra, {|nn,i| _aTotCli[i]:=_aTotCli[i] + nn})
		EndDo
		
		If Li >59
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			Li := 9
		Endif
		
		@ Li,001 Psay padr("Total Cliente",50,".")
		@ Li,051 Psay "("+Alltrim(Str(_aTotCli[NROREGS]))+" Docs)"
		@ Li,071 Psay tran(_aTotCli[QTDE],_cPicD2_QUANT)
		@ Li,096 Psay tran(_aTotCli[VLUNIT],_cPicF2_VALMERC)
		@ Li,110 Psay tran(_aTotCli[VLSERV] ,_cPicF2_VALBRUT)
		@ Li,124 Psay tran(_aTotCli[VLFRETE],_cPicF2_FRETE)
		@ Li,136 Psay tran(_aTotCli[VLBRUTO],_cPicF2_VALBRUT)
		@ Li,152 Psay tran( Eval(bPrUnit, _aTotCli[VLBRUTO], _aTotCli[QTDE]), _cPicD2_PRCVEN)
		@ ++Li,001 PSAY REPLICATE("=",220)
		
		Li+=1
		
		//Acumula o Total Geral do Relatorio
		AEval( _aTotCli, {|nn,i| _aTotGer[i]:=_aTotGer[i] + nn})
		
	EndDo

	If Li >59.and. !lAbortPrint
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		Li := 9
	Endif

	If !lAbortPrint
		@ Li,001 Psay padr("Total Geral",46,".")
		@ Li,047 Psay "("+Alltrim(Str(_aTotGer[NROREGS]))+" Docs)"
		@ Li,071 Psay tran(_aTotGer[QTDE]   ,_cPicF2_VALBRUT)
	//	@ Li,071 Psay tran(_aTotGer[QTDE]   ,_cPicD2_QUANT)
		@ Li,096 Psay tran(_aTotGer[VLUNIT] ,_cPicF2_VALMERC)
		@ Li,110 Psay tran(_aTotGer[VLSERV] ,_cPicF2_VALBRUT)
		@ Li,124 Psay tran(_aTotGer[VLFRETE],_cPicF2_VALBRUT)
		@ Li,136 Psay tran(_aTotGer[VLBRUTO],_cPicF2_VALBRUT)
		@ Li,152 Psay tran( Eval(bPrUnit, _aTotGer[VLBRUTO], _aTotGer[QTDE]), _cPicD2_PRCVEN)
	Else
		@ li,001 Psay "Impressao cancelada pelo operador......"
	EndIf

	Li++

	@ Li,001 PSAY Replicate("=",220)

	SET DEVICE TO SCREEN

	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif

	MS_FLUSH()

	Return

	Static Function PDFATR26_Consulta()

	LOCAL nOrdRel:=aReturn[8]

	MsProcTxt("Levantando NF´s do Periodo "+DTOC(mv_par01)+" a "+DTOC(mv_par02))

	_cQuery := "SELECT ' ' AS ORIGEM,SF2.F2_CLIENTE,SF2.F2_LOJA,SF2.F2_DOC,SF2.F2_HORA,SF2.F2_EMISSAO,"+CRLF
	_cQuery += " SF2.F2_VEND1,SF2.F2_VALMERC,SF2.F2_FRETE,SF2.F2_VALBRUT,"+CRLF
	_cQuery += " CASE WHEN SD2.D2_COD='0SERVICO' THEN 0 ELSE SD2.D2_TOTAL END AS VALITMERC,"+CRLF
	_cQuery += " SD2.D2_PRCVEN AS D2_PRCVEN,D2_QTDEDEV,"+CRLF
	_cQuery += " SD2.D2_QUANT as QTITMERC,"+CRLF
	_cQuery += "(SELECT AA.D2_TOTAL FROM "+RETSQLNAME("SD2")+" AS AA WHERE AA.D_E_L_E_T_='' AND AA.D2_DOC=SD2.D2_DOC AND AA.D2_FILIAL=SD2.D2_FILIAL AND AA.D2_CLIENTE=SD2.D2_CLIENTE AND AA.D2_LOJA=SD2.D2_LOJA AND AA.D2_COD='0SERVICO') AS VALITSERV,"+CRLF
	_cQuery += " CASE WHEN D2_ITEM='01' THEN F2_FRETE ELSE 0 END AS VALFRETE,"+CRLF
	_cQuery += " SC5.C5_CODEE, SC5.C5_DESCEE, "+CRLF
	_cQuery += " SD2.* "+CRLF
	_cQuery += "FROM  "
	_cQuery += RETSQLNAME("SF2")+" AS SF2, "
	_cQuery += RETSQLNAME("SC5")+" AS SC5, "
	_cQuery += RETSQLNAME("SD2")+" AS SD2, "
	_cQuery += RETSQLNAME("SF4")+" AS SF4 "+CRLF
	_cQuery += "WHERE SF2.D_E_L_E_T_ = '' "+CRLF
	_cQuery += "AND      SD2.D_E_L_E_T_ = '' "+CRLF
	_cQuery += "AND      SC5.D_E_L_E_T_ = '' "+CRLF
	_cQuery += "AND      SF4.D_E_L_E_T_ = '' "+CRLF
	_cQuery += "AND      SF2.F2_FILIAL ='"+xfilial("SF2")+"' "+CRLF
	_cQuery += "AND      SD2.D2_FILIAL ='"+xfilial("SD2")+"' "+CRLF
	_cQuery += "AND      SC5.C5_FILIAL ='"+xfilial("SC5")+"' "+CRLF
	_cQuery += "AND      SF4.F4_FILIAL ='"+xfilial("SF4")+"' "+CRLF
	_cQuery += "AND      SD2.D2_DOC = SF2.F2_DOC "+CRLF
	_cQuery += "AND      SD2.D2_SERIE = SF2.F2_SERIE "+CRLF
	_cQuery += "AND      SD2.D2_CLIENTE = SF2.F2_CLIENTE "+CRLF
	_cQuery += "AND      SD2.D2_LOJA = SF2.F2_LOJA "+CRLF
	_cQuery += "AND      SD2.D2_PEDIDO = SC5.C5_NUM "+CRLF
	_cQuery += "AND      SD2.D2_TES = SF4.F4_CODIGO "+CRLF
	_cQuery += "AND      SF2.F2_EMISSAO BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"' "+CRLF
	_cQuery += "AND      SF2.F2_CLIENTE BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "+CRLF
	_cQuery += "AND      SD2.D2_COD     BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "+CRLF
	_cQuery += "AND      (SD2.D2_COD <> '0SERVICO' OR SD2.D2_TOTAL=SF2.F2_VALMERC) "+CRLF
	If cEmpAnt == "04"
		IIF(Type("MV_PAR07")=="N",_cQuery+="AND SF2.F2_XOPESAI = '"+aOpeSai[MV_PAR07,1]+"' "+CRLF,NIL)
	Endif
	_cQuery += "ORDER BY SF2.F2_CLIENTE,SF2.F2_LOJA,SC5.C5_CODEE,SD2.D2_COD,"+IIF(nOrdRel=1,"SF2.F2_DOC","SF2.F2_EMISSAO")

	TCQUERY _cQuery NEW ALIAS "TMP"  

	//_cQuery :=ChangeQuery(_cQuery)

	Memowrit("c:\temp\PDFATR26.sql",_cQuery)

	//dBUseArea(.t.,"TOPCONN",TCGENQRY(,,_cQUERY),"TMP",.f.,.t.)  // EXECUTA query

	TcSetField("TMP","F2_EMISSAO","D",8,0)
	TcSetField("TMP","F2_VALMERC","N",14,2)
	TcSetField("TMP","F2_VALBRUT","N",14,2)
	TcSetField("TMP","F2_FRETE","N",14,2)
	TcSetField("TMP","D2_PRCVEN","N",14,2)
	TcSetField("TMP","D2_QUANT","N",11,2)
	TcSetField("TMP","VALITMERC","N",17,2)
	TCSETFIELD("TMP","D2_PRUNIT","N",16,2) 
	TCSETFIELD("TMP","D2_TOTAL" ,"N",17,2)   
	TCSETFIELD("TMP","D2_BASIMP5","N",17,2)   
	TCSETFIELD("TMP","D2_BASIMP6","N",17,2)    
	TCSETFIELD("TMP","D2_VALBRUT","N",17,2)  


	_cArq2 := CriaTrab(NIL,.F.)
	Copy To &_cArq2

	dbCloseArea()

	dbUseArea(.T.,,_cArq2,"TMP",.T.)

	IF nOrdRel = 1
		_cInd2 := "F2_CLIENTE + F2_LOJA + C5_CODEE + D2_COD + F2_DOC"
	Else
		_cInd2 := "F2_CLIENTE + F2_LOJA + C5_CODEE + D2_COD + DTOS(F2_EMISSAO)"
	Endif

	IndRegua("TMP",_cArq2,_cInd2,,,"Selecionando Arquivo Trabalho")

	_cQ := " SELECT * FROM "+RetSqlname("SZJ")+" A WHERE A.D_E_L_E_T_ = '' "
	_cQ += " AND ZJ_DTEMIS  BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"' "
	_cQ += " AND ZJ_CLIENTE BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "
	_cQ += " AND ZJ_PRODUTO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "
	_cQ += " AND ZJ_FILIAL = '"+xFilial("SZJ")+"' "
	_cQ += " ORDER BY ZJ_CLIENTE,ZJ_LOJA "

	TCQUERY _cQ NEW ALIAS "ZZ"

	ZZ->(dbGotop())

	While ZZ->(!Eof())
		
		SC5->(dbSetorder(1))
		SC5->(dbSeek(xFilial("SC5")+ZZ->ZJ_PEDIDO))
		
		TMP->(RecLock("TMP",.T.))
		TMP->F2_CLIENTE  := ZZ->ZJ_CLIENTE
		TMP->F2_LOJA     := ZZ->ZJ_LOJA
		TMP->F2_DOC      := ZZ->ZJ_DOC
		TMP->F2_HORA     := ZZ->ZJ_HORAEMI
		TMP->F2_EMISSAO  := STOD(ZZ->ZJ_DTEMIS)
		TMP->F2_VEND1    := ZZ->ZJ_VEND1
		TMP->F2_VALMERC  := ZZ->ZJ_VALMERC
		TMP->F2_FRETE    := ZZ->ZJ_VALFRET
		TMP->F2_VALBRUT  := ZZ->ZJ_VALBRUT
		TMP->VALITMERC   := ZZ->ZJ_TOTITEM
		TMP->D2_PRCVEN   := ZZ->ZJ_PRCVEN
		TMP->D2_COD      := ZZ->ZJ_PRODUTO
		TMP->QTITMERC    := ZZ->ZJ_QTDITEM
		TMP->C5_CODEE    := SC5->C5_CODEE
		TMP->C5_DESCEE   := SC5->C5_DESCEE
		TMP->ORIGEM      := "C"
		TMP->(MsUnlock())
		
		ZZ->(dbSkip())
	EndDo

	ZZ->(dbCloseArea())

	Return(.T.)

	Static Function VALIDPERG(_cPerg1)

	ssAlias  := Alias()
	aRegs   := {}

	dbSelectArea("SX1")
	dbSetOrder(1)
	*   1    2            3                4     5   6  7 8  9  10   11        12    13 14    15    16 17 18 19 20 21 22 23 24 25  26
	*+---------------------------------------------------------------------------------------------------------------------------------+
	*¦G    ¦ O  ¦ PERGUNT              ¦V       ¦T  ¦T ¦D¦P¦ G ¦V ¦V         ¦ D    ¦C ¦V ¦D       ¦C ¦V ¦D ¦C ¦V ¦D ¦C ¦V ¦D ¦C ¦F    ¦
	*¦ R   ¦ R  ¦                      ¦ A      ¦ I ¦A ¦E¦R¦ S ¦A ¦ A        ¦  E   ¦N ¦A ¦ E      ¦N ¦A ¦E ¦N ¦A ¦E ¦N ¦A ¦E ¦N ¦3    ¦
	*¦  U  ¦ D  ¦                      ¦  R     ¦  P¦MA¦C¦E¦ C ¦ L¦  R       ¦   F  ¦ T¦ R¦  F     ¦ T¦R ¦F ¦ T¦R ¦F ¦ T¦R ¦F ¦ T¦     ¦
	*¦   P ¦ E  ¦                      ¦   I    ¦  O¦NH¦ ¦S¦   ¦ I¦   0      ¦    0 ¦ 0¦ 0¦   0    ¦ 0¦0 ¦0 ¦ 0¦0 ¦0 ¦ 0¦0 ¦0 ¦ 0¦     ¦
			*¦    O¦ M  ¦                      ¦    AVL ¦   ¦ O¦ ¦E¦   ¦ D¦    1     ¦    1 ¦ 1¦ 2¦    2   ¦ 2¦3 ¦3 ¦ 3¦4 ¦4 ¦ 4¦5 ¦5 ¦ 5¦     ¦
	AADD(aRegs,{cPerg,"01","Data Inicial       :","mv_ch1","D",08,0,0,"G","","mv_par01",""    ,"","",""      ,"","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"02","Data Final         :","mv_ch2","D",08,0,0,"G","","mv_par02",""    ,"","",""      ,"","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"03","Do Cliente         ?","mv_ch3","C",06,0,0,"G","","mv_par03",""    ,"","",""      ,"","","","","","","","","","","CLI"})
	AADD(aRegs,{cPerg,"04","Ate o Cliente      ?","mv_ch4","C",06,0,0,"G","","mv_par04",""    ,"","",""      ,"","","","","","","","","","","CLI"})
	AADD(aRegs,{cPerg,"05","Do Produto         ?","mv_ch5","C",15,0,0,"G","","mv_par05",""    ,"","",""      ,"","","","","","","","","","","SB1"})
	AADD(aRegs,{cPerg,"06","Ate o Produto      ?","mv_ch6","C",15,0,0,"G","","mv_par06",""    ,"","",""      ,"","","","","","","","","","","SB1"})
	AADD(aRegs,{cPerg,"08","Da Transp          ?","mv_ch8","C",06,0,0,"G","","mv_par08",""    ,"","",""      ,"","","","","","","","","","","SA4"})
	AADD(aRegs,{cPerg,"09","Ate a Transp       ?","mv_ch9","C",06,0,0,"G","","mv_par09",""    ,"","",""      ,"","","","","","","","","","","SA4"})

	u__fAtuSx1(padr(_cPerg1,len(sx1->x1_grupo)),aRegs)

	Return(.T.)