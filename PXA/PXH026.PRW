#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

/*/
Função			:	PXH026
Autor			:	Alexandro da Silva
Data 			: 	17.07.2012
Descrição		: 	Atualiza Demonstrativo de Resultado (Tabela SZ7)
/*/

User Function PXH026(_cSched)

LOCAL oDlg := NIL

PRIVATE cTitulo    	:= "Copiar Registros"
Private _dFirstD,_dLastD
Private cPerg   	:= "PXH026"

Private _cMsg01    	:= ''
Private _lFim      	:= .F.
Private _lAborta01 	:= .T.
Private _lSchedule  := If(_cSched = Nil, .F.,.T.)

Conout('schedule')
Conout(_cSched)
If _lSchedule
	PREPARE ENVIRONMENT EMPRESA "16" FILIAL "09201"
	
	CONOUT("Início Atualização DRE")
	
	PXH026B(@_lFim)
	
	CONOUT("Fim Atualização DRE")
	
	RESET ENVIRONMENT
	
Else
	
	ATUSX1()
	
	_nOpc := 0
	DEFINE MSDIALOG oDlg FROM 264,182 TO 441,613 TITLE cTitulo OF oDlg PIXEL
	
	@ 010,017 SAY "Esta rotina tem por objetivo gerar os Dados     " OF oDlg PIXEL Size 150,010
	@ 020,017 SAY "Para o DEMONSTRATIVO DE RESULTADO Conforme      " OF oDlg PIXEL Size 150,010
	@ 040,017 SAY "Visao Gerencial.                                " OF oDlg PIXEL Size 150,010
	
	@ 35,167 BUTTON "Parametros" SIZE 036,012 ACTION (Pergunte("PXH026",.T.)) 	OF oDlg PIXEL
	@ 50,167 BUTTON "OK" 		  SIZE 036,012 ACTION (_nOpc := 1,oDlg:End()) 	OF oDlg PIXEL
	@ 65,167 BUTTON "Sair"       SIZE 036,012 ACTION ( oDlg:End()) 				OF oDlg PIXEL
	
	ACTIVATE MSDIALOG oDlg CENTERED
	
	If _nOpc = 1
		
		Private _bAcao01       := {|_lFim| PXH026B(@_lFim) }    /// CONFORME SZQ VISAO 003
		Private _cTitulo01 := 'Processando...'
		Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

		Private _bAcao01       := {|_lFim| PXH026C(@_lFim) }    /// CONFORME SD2 VISAO 005
		Private _cTitulo01 := 'Processando...'
		Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
		
	Endif
Endif

Return(Nil)



Static Function PXH026B(_lFim)

Local nRegCT2   := CT2->(Recno())
Local nRegCTS   := CTS->(Recno())
Local aStru		 := CTS->(DbStruct()), nI
Local cQuery

If !_lSchedule
	Pergunte("PXH026",.F.)
Else
	MV_PAR01 := ctod('01/01/2015')
	MV_PAR02 := ctod('31/12/2020')
	
	CONOUT(MV_PAR01)
	CONOUT(MV_PAR02)
Endif

_cAno1   := LEFT(DTOS(STOD(LEFT(DTOS(MV_PAR01),4)+"0101")-1),4)
_cAnoAnt := _cAno1 + "01"
_cAnoFim := _cAno1 + "12"

_cVis1 := Alltrim(GetMv("PXH_VISAO2"))  // VISAO 003 ou VISAO 001 (PARA VILA NOVA)

_cVisao := "('"
For Ax:= 1 To Len(_cVis1)
	If Substr(_cVis1,AX,1) != "*"
		_cVisao += Substr(_cVis1,AX,1)
	Else
		_cVisao += "','"
	Endif
Next AX

_cVisao += "')"

_cQ := " DELETE "+RetSqlName("SZ7")+" WHERE Z7_FILIAL = '"+xFilial("SZ7")+"' "
_cQ += " AND Z7_PERIODO BETWEEN  '"+_cAnoAnt+"' AND '"+_cAnoFim+"' AND Z7_CODPLA IN "+_cVisao+" "
TCSQLEXEC(_cQ)

_cQ := " DELETE "+RetSqlName("SZ7")+" WHERE Z7_FILIAL = '"+xFilial("SZ7")+"' "
_cQ += " AND Z7_PERIODO BETWEEN '"+LEFT(DTOS(MV_PAR01),6)+"' AND '"+LEFT(DTOS(MV_PAR02),6)+"' AND Z7_CODPLA IN "+_cVisao+" "
TCSQLEXEC(_cQ)

aCampos := {}

AADD(aCampos,{"FILIAL"	    ,"C" ,05,0	})
AADD(aCampos,{"VISAO"	    ,"C" ,03,0	})
AADD(aCampos,{"LINHA"	    ,"C" ,03,0	}) // LINHA CTS_LINHA
AADD(aCampos,{"ENTID"	    ,"C" ,20,0	})
AADD(aCampos,{"DESCR"	    ,"C" ,40,0	})
AADD(aCampos,{"PERIO"	    ,"C" ,06,0	})
AADD(aCampos,{"VALOR"	    ,"N" ,17,2	})

cArqTemp	:=	CriaTrab(aCampos)

If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
Endif

dbUseArea(.T.,,cArqTemp,"TRB",.F.,.F.)

IndRegua("TRB",cArqTemp,"FILIAL+VISAO+LINHA+ENTID+PERIO",,,"Indexando Dados")

_dFirstD  := FirstDay(MV_PAR01)
_dLastD   := LastDay(MV_PAR02)

// Obtem os registros a serem processados

cQuery := " SELECT * FROM "+RetSqlName("CTS")+" CTS "
cQuery += " WHERE CTS.D_E_L_E_T_ = '' AND CTS_CODPLA IN "+_cVisao+" "
cQuery += " AND CTS_CT1INI <> '' AND CTS_FILIAL = '"+xFilial("CTS")+"' "//CTS_CONTAG IN ('07.01','07.08') "
cQuery += " ORDER BY CTS_CODPLA,CTS_ORDEM "

TCQUERY cQuery NEW ALIAS "NEWCTS"

For nI := 1 TO LEN(aStru)
	If aStru[nI][2] != "C"
		TCSetField("NEWCTS", aStru[nI][1], aStru[nI][2], aStru[nI][3], aStru[nI][4])
	EndIf
Next

cNomeArq := CriaTrab(Nil,.F.)
IndRegua("NEWCTS",cNomeArq,"CTS_FILIAL+CTS_CODPLA+CTS_ORDEM",,,"Selecionando Registros...")

NEWCTS->(dbGoTop())

ProcRegua(NEWCTS->(LASTREC()))

While NEWCTS->(!Eof())
	
	IncProc()
	
	If NEWCTS->CTS_CONTAG = '11.4'
		_lParar := .T.
	Endif
	
	If NEWCTS->CTS_SLDENT <> "3"
		//Verifica Crédito
		cQuer1 := " SELECT R_E_C_N_O_ AS RECSZQ,* FROM "+RetSqlName("SZQ")+" A "
		cQuer1 += " WHERE A.D_E_L_E_T_ = '' AND ZQ_FILIAL = '"+xFilial("SZQ")+" ' "
		cQuer1 += " AND ZQ_DTDIGIT 	BETWEEN '"+DTOS(_dFirstD)+"' 		AND '"+DTOS(_dLastD)+"' "
		cQuer1 += " AND ZQ_CONTA    BETWEEN '"+NEWCTS->CTS_CT1INI+"' AND  '"+NEWCTS->CTS_CT1FIM+"' "
		cQuer1 += " AND ZQ_YCC  	BETWEEN '"+NEWCTS->CTS_CTTINI+"' AND  '"+NEWCTS->CTS_CTTFIM+"' "
		cQuer1 += " AND ZQ_ITEMCTA 	BETWEEN '"+NEWCTS->CTS_CTDINI+"' AND  '"+NEWCTS->CTS_CTDFIM+"' "
		cQuer1 += " AND ZQ_CLVL     BETWEEN '"+NEWCTS->CTS_CTHINI+"' AND  '"+NEWCTS->CTS_CTHFIM+"' "
		cQuer1 += " ORDER BY ZQ_DTDIGIT "
		
		TCQUERY cQuer1 NEW ALIAS "ZZ"
		
		TCSETFIELD("ZZ","ZQ_DTDIGIT","D")
		TCSETFIELD("ZZ","ZQ_TOTAL","N",17,2)
		
		ZZ->(dbGoTop())
		
		While ZZ->(!Eof())
			
			_cAno     := Right(Str(YEAR(ZZ->ZQ_DTDIGIT)),4)
			_cMonth   := STRZERO(Month(ZZ->ZQ_DTDIGIT),2)
			_cSeek    := NEWCTS->CTS_FILIAL+NEWCTS->CTS_CODPLA+NEWCTS->CTS_LINHA+NEWCTS->CTS_CONTAG+_cAno+_cMonth
			
			_nValor  := ZZ->ZQ_TOTAL
			
			If !TRB->(dbSeek(_cSeek))
				TRB->(RecLock("TRB",.T.))
				TRB->FILIAL	:= NEWCTS->CTS_FILIAL
				TRB->VISAO	:= NEWCTS->CTS_CODPLA
				TRB->LINHA	:= NEWCTS->CTS_LINHA
				TRB->ENTID	:= NEWCTS->CTS_CONTAG
				TRB->DESCR	:= NEWCTS->CTS_DESCCG
				TRB->PERIO  := _cAno+_cMonth
				TRB->VALOR  := _nValor
				TRB->(Msunlock("TRB"))
			Else
				TRB->(RecLock("TRB",.F.))
				TRB->VALOR  += _nValor
				TRB->(Msunlock("TRB"))
			Endif
			
			SZQ->(dbGoto(ZZ->RECSZQ))
			SZQ->(RecLock("SZQ",.F.))
			SZQ->ZQ_CODVISA := NEWCTS->CTS_CODPLA
			SZQ->ZQ_DESVISA := NEWCTS->CTS_DESCCG
			SZQ->ZQ_CONTVIS := NEWCTS->CTS_CONTAG
			SZQ->(MsUnLock())
			
			ZZ->(dbSkip())
		EndDo
		
		ZZ->(dbCloseArea())
		
	Endif
	
	_cChav := NEWCTS->CTS_FILIAL + NEWCTS->CTS_CODPLA + NEWCTS->CTS_LINHA + NEWCTS->CTS_CONTAG
	
	If TRB->(dbSeek(_cChav))
		
		_cChavTRB := TRB->FILIAL + TRB->VISAO	+ TRB->LINHA + TRB->ENTID
		
		While TRB->(!Eof()) .And. _cChavTRB == TRB->FILIAL + TRB->VISAO	+ TRB->LINHA + TRB->ENTID
			
			If NEWCTS->CTS_IDENT == "2"
				TRB->VALOR := TRB->VALOR * -1
			Endif
			
			TRB->(dbSkip())
		EndDo
	Endif
	
	NEWCTS->(dbSKIP())
EndDo

TRB->(dbgoTop())

While TRB->(!EOF())
	
	SZ7->(dbSetorder(1))
	If SZ7->(dbSeek(xFilial("SZ7" ) + TRB->VISAO + TRB->LINHA + TRB->ENTID + TRB->PERIO ))
		SZ7->(RecLock("SZ7",.F.))
		SZ7->Z7_VALOR	 += TRB->VALOR
		SZ7->(MsUnLock())
	Else
		SZ7->(RecLock("SZ7",.T.))
		SZ7->Z7_FILIAL	 := xFilial("SZ7")
		SZ7->Z7_CODPLA	 := TRB->VISAO
		SZ7->Z7_ORDEM	 := TRB->LINHA
		SZ7->Z7_CONTAG	 := TRB->ENTID
		SZ7->Z7_DESCCG	 := TRB->DESCR
		SZ7->Z7_VALOR	 := TRB->VALOR
		SZ7->Z7_PERIODO  := TRB->PERIO
		SZ7->(MsUnLock())
	Endif
	
	TRB->(dbskip())
EndDo

TRB->(dbCloseArea())

NEWCTS->(dbCloseArea())

If cNomeArq # Nil
	Ferase(cNomeArq+OrdBagExt())
Endif

Return

Static Function PXH026C(_lFim)

Local nRegCT2   := CT2->(Recno())
Local nRegCTS   := CTS->(Recno())
Local aStru		 := CTS->(DbStruct()), nI
Local cQuery

Pergunte("PXH026",.F.)

_cAno1   := LEFT(DTOS(STOD(LEFT(DTOS(MV_PAR01),4)+"0101")-1),4)
_cAnoAnt := _cAno1 + "01"
_cAnoFim := _cAno1 + "12"

_cQ := " DELETE "+RetSqlName("SZ7")+" WHERE Z7_FILIAL = '"+xFilial("SZ7")+"' "
_cQ += " AND Z7_PERIODO BETWEEN  '"+_cAnoAnt+"' AND '"+_cAnoFim+"' AND Z7_CODPLA = '005' "
TCSQLEXEC(_cQ)

_cQ := " DELETE "+RetSqlName("SZ7")+" WHERE Z7_FILIAL = '"+xFilial("SZ7")+"' "
_cQ += " AND Z7_PERIODO BETWEEN '"+LEFT(DTOS(MV_PAR01),6)+"' AND '"+LEFT(DTOS(MV_PAR02),6)+"' AND Z7_CODPLA = '005' "
TCSQLEXEC(_cQ)

aCampos := {}

AADD(aCampos,{"FILIAL"	    ,"C" ,05,0	})
AADD(aCampos,{"VISAO"	    ,"C" ,03,0	})
AADD(aCampos,{"LINHA"	    ,"C" ,03,0	})
AADD(aCampos,{"ENTID"	    ,"C" ,20,0	})
AADD(aCampos,{"DESCR"	    ,"C" ,40,0	})
AADD(aCampos,{"PERIO"	    ,"C" ,06,0	})
AADD(aCampos,{"VALOR"	    ,"N" ,17,2	})

cArqTemp	:=	CriaTrab(aCampos)

dbUseArea(.T.,,cArqTemp,"TRB",.F.,.F.)

IndRegua("TRB",cArqTemp,"FILIAL+VISAO+LINHA+ENTID+PERIO",,,"Indexando Dados")

_dFirstD  := FirstDay(MV_PAR01)
_dLastD   := LastDay(MV_PAR02)

_cVisao := "('005')"

_cProd    := Alltrim(GetMv("PXH_PRDDRE"))  // PRODUTOS DO OURO
_cProduto := "('"

For Ax:= 1 To Len(_cProd)
	If Substr(_cProd,AX,1) != "*"
		_cProduto += Substr(_cProd,AX,1)
	Else
		_cProduto += "','"
	Endif
Next AX

_cProduto += "')"

cQuery := " SELECT * FROM "+RetSqlName("CTS")+" CTS "
cQuery += " WHERE CTS.D_E_L_E_T_ = '' AND CTS_CODPLA IN "+_cVisao+" "
cQuery += " AND CTS_FILIAL = '"+xFilial("CTS")+"' "
cQuery += " ORDER BY CTS_CODPLA,CTS_ORDEM "

TCQUERY cQuery NEW ALIAS "NEWCTS"

For nI := 1 TO LEN(aStru)
	If aStru[nI][2] != "C"
		TCSetField("NEWCTS", aStru[nI][1], aStru[nI][2], aStru[nI][3], aStru[nI][4])
	EndIf
Next

_cEmp := Left(cFilAnt,3)

cNomeArq := CriaTrab(Nil,.F.)
IndRegua("NEWCTS",cNomeArq,"CTS_FILIAL+CTS_CODPLA+CTS_ORDEM",,,"Selecionando Registros...")

_cQ := " SELECT LEFT(D2_EMISSAO,6) AS ANOMES,D2_COD AS PRODUTO,D2_CLIENTE AS CLIENTE,D2_LOJA AS LOJA,SUM(D2_QUANT) AS QUANT, SUM(D2_TOTAL) AS VALTOT, SUM(D2_VALIMP6) AS VALPIS, "
_cQ += " SUM(D2_VALIMP5) AS VALCOF,SUM(D2_VALICM) AS VALICM, SUM(D2_VALFRE) AS VALFRE FROM "+RetSqlName("SD2")+" A "
_cQ += " INNER JOIN "+RetSqlName("SF4")+" B ON D2_TES=F4_CODIGO "
_cQ += " WHERE A.D_E_L_E_T_ = '' AND B.D_E_L_E_T_ = ''  AND LEFT(D2_FILIAL,3) = '"+_cEmp+"' "
//_cQ += " AND F4_DUPLIC = 'S' AND D2_TIPO = 'N' AND LEFT(D2_COD,4) IN ('V001','V002','V003','V005') " 
_cQ += " AND F4_DUPLIC = 'S' AND D2_TIPO = 'N' AND LEFT(D2_COD,4) IN ('V002') "
_cQ += " AND D2_EMISSAO BETWEEN '"+DTOS(_dFirstD)+"' AND '"+DTOS(_dLastD)+"' "
_cQ += " GROUP BY LEFT(D2_EMISSAO,6),D2_COD,D2_CLIENTE,D2_LOJA "
_cQ += " ORDER BY LEFT(D2_EMISSAO,6),D2_COD,D2_CLIENTE,D2_LOJA "

MemoWrite("C:\TEMP\PXH026.TXT",_cQ)

TCQUERY _cQ NEW ALIAS "ZZ"

TCSETFIELD("ZZ","QUANT" ,"N",17,2)
TCSETFIELD("ZZ","VALTOT","N",17,2)
TCSETFIELD("ZZ","VALPIS","N",17,2)
TCSETFIELD("ZZ","VALCOF","N",17,2)
TCSETFIELD("ZZ","VALICM","N",17,2)
TCSETFIELD("ZZ","VALFRE","N",17,2)

_cQ := " SELECT LEFT(D1_DTDIGIT,6) AS ANOMES,D1_COD AS PRODUTO,D1_FORNECE AS CLIENTE,D1_LOJA AS LOJA,SUM(D1_QUANT) AS QUANT, SUM(D1_TOTAL) AS VALTOT, SUM(D1_VALIMP6) AS VALPIS, "
_cQ += " SUM(D1_VALIMP5) AS VALCOF,SUM(D1_VALICM) AS VALICM, SUM(D1_VALFRE) AS VALFRE FROM "+RetSqlName("SD1")+" A "
_cQ += " INNER JOIN "+RetSqlName("SF4")+" B ON D1_TES=F4_CODIGO "
_cQ += " WHERE A.D_E_L_E_T_ = '' AND B.D_E_L_E_T_ = ''  AND LEFT(D1_FILIAL,3) = '"+_cEmp+"' "
//_cQ += " AND F4_DUPLIC = 'S' AND D1_TIPO = 'D' AND LEFT(D1_COD,4) IN ('V001','V002','V003','V005') " 
_cQ += " AND F4_DUPLIC = 'S' AND D1_TIPO = 'D' AND LEFT(D1_COD,4) IN ('V002') "
_cQ += " AND D1_DTDIGIT BETWEEN '"+DTOS(_dFirstD)+"' AND '"+DTOS(_dLastD)+"' "
_cQ += " GROUP BY LEFT(D1_DTDIGIT,6),D1_COD,D1_FORNECE,D1_LOJA "
_cQ += " ORDER BY LEFT(D1_DTDIGIT,6),D1_COD,D1_FORNECE,D1_LOJA "

MemoWrite("C:\TEMP\PXH026B.TXT",_cQ)

TCQUERY _cQ NEW ALIAS "ZZ2"

TCSETFIELD("ZZ2","QUANT" ,"N",17,2)
TCSETFIELD("ZZ2","VALTOT","N",17,2)
TCSETFIELD("ZZ2","VALPIS","N",17,2)
TCSETFIELD("ZZ2","VALCOF","N",17,2)
TCSETFIELD("ZZ2","VALICM","N",17,2)
TCSETFIELD("ZZ2","VALFRE","N",17,2)

/*
_cQ := " SELECT LEFT(D1_DTDIGIT,6) AS ANOMES,LEFT(D1_CC,2) AS CCUSTO,SUM(D1_QUANT) AS QUANT, SUM(D1_TOTAL) AS VALTOT, SUM(D1_VALIMP5) AS VALPIS, "
_cQ += " SUM(D1_VALIMP6) AS VALCOF FROM "+RetSqlName("SD1")+" A "
_cQ += " INNER JOIN "+RetSqlName("SF4")+" B ON D1_TES=F4_CODIGO "
_cQ += " WHERE A.D_E_L_E_T_ = '' AND B.D_E_L_E_T_ = '' AND LEFT(D1_FILIAL,3) = '"+_cEmp+"' "
_cQ += " AND F4_DUPLIC = 'S' AND D1_TIPO = 'N' "
_cQ += " AND D1_DTDIGIT BETWEEN '"+DTOS(_dFirstD)+"' AND '"+DTOS(_dLastD)+"' "
_cQ += " GROUP BY LEFT(D1_DTDIGIT,6),LEFT(D1_CC,2) "
_cQ += " ORDER BY LEFT(D1_DTDIGIT,6),LEFT(D1_CC,2) "

TCQUERY _cQ NEW ALIAS "ZZD1"

TCSETFIELD("ZZD1","QUANT" ,"N",17,2)
TCSETFIELD("ZZD1","VALTOT","N",17,2)
TCSETFIELD("ZZD1","VALPIS","N",17,2)
TCSETFIELD("ZZD1","VALCOF","N",17,2)

_cQ := " SELECT E2_EMIS1,E2_BAIXA,SUM(E2_VALOR) AS VALOR FROM "+RetSqlName("SE2")+" A "
_cQ += " WHERE A.D_E_L_E_T_ = '' AND E2_FILIAL = '"+xFilial("SE2")+"' "
_cQ += " AND E2_TIPO IN  ('NF','DP','FT') "
_cQ += " AND E2_EMIS1   BETWEEN '"+DTOS(_dFirstD)+"' AND '"+DTOS(_dLastD)+"' AND E2_BAIXA <> '' "
_cQ += " GROUP BY E2_EMIS1,E2_BAIXA"
_cQ += " ORDER BY E2_EMIS1 "

TCQUERY _cQ NEW ALIAS "ZZE2"

TCSETFIELD("ZZE2","E2_EMIS1"  ,"D",08)
TCSETFIELD("ZZE2","E2_BAIXA"  ,"D",08)
TCSETFIELD("ZZE2","VALOR"     ,"N",17,2)
*/
NEWCTS->(dbGoTop())

ProcRegua(NEWCTS->(LASTREC()))

_cANOMES:= LEFT(DTOS(MV_PAR01),6)

While NEWCTS->(!Eof())
	
	IncProc()
	
	_nValor := 0
	
	If Alltrim(NEWCTS->CTS_CONTAG) $ "2.01/2.02/2.03/2.04/3.01/3.02/3.03/3.04/3.05/3.06/3.07/3.08/4.01/4.02/4.03"
		
		ZZ->(dbgotop())
		While ZZ->(!Eof())
                    
			_nQuant   := 0
			_cUnidMed := "2" // 2 - SEGUNDA UNIDADE DE MEDIDA
			
			SB1->(dbSetOrder(1))
			If SB1->(dbSeek(xFilial("SB1") + ZZ->PRODUTO))
				If !Empty(SB1->B1_SEGUM) .And. SB1->B1_CONV > 0
					SA7->(dbSetOrder(1))
					If SA7->(dbSeek(xFilial("SA7") + ZZ->CLIENTE + ZZ->LOJA + ZZ->PRODUTO))
						_cUnidMed := SA7->A7_YTPVEND  // 1- PRIMEIRA UNIDADE DE MEDIDA
					Endif               
					     
					If _cUnidMed  == "1" .And. SB1->B1_UM <> "KG"
						If SB1->B1_TIPCONV == "M"
							_nQuant := (ZZ->QUANT / SB1->B1_CONV)
						Else
							_nQuant := (ZZ->QUANT * SB1->B1_CONV)
						Endif
					Else
						_nQuant := ZZ->QUANT					
					Endif
				Else
					_nQuant := ZZ->QUANT
				Endif
			Else                    				
				_nQuant := ZZ->QUANT			           				
			Endif				
									
			If Alltrim(NEWCTS->CTS_CONTAG) = "2.01"
				If LEFT(ZZ->PRODUTO,4) != "V002"
					ZZ->(dbSkip())
					Loop
				Endif 
				_nValor := _nQuant
			ElseIf Alltrim(NEWCTS->CTS_CONTAG) = "2.02"
				If LEFT(ZZ->PRODUTO,4) != "V001"
					ZZ->(dbSkip())   
					Loop
				Endif
				_nValor := _nQuant
			ElseIf Alltrim(NEWCTS->CTS_CONTAG) = "2.03"
				If LEFT(ZZ->PRODUTO,4) != "V005"
					ZZ->(dbSkip())
					Loop
				Endif
				_nValor := _nQuant
			ElseIf Alltrim(NEWCTS->CTS_CONTAG) = "2.04"
				If LEFT(ZZ->PRODUTO,4) != "V003"
					ZZ->(dbSkip())
					Loop
				Endif
				_nValor := _nQuant
			ElseIf Alltrim(NEWCTS->CTS_CONTAG) = "3.01" // VENDA COM FRETE
				If LEFT(ZZ->PRODUTO,4) != "V002"
					ZZ->(dbSkip())
					Loop
				Endif
				_nValor := ZZ->VALTOT + ZZ->VALFRE
			ElseIf Alltrim(NEWCTS->CTS_CONTAG) = "3.02" // VENDA COM FRETE
				If LEFT(ZZ->PRODUTO,4) != "V001"
					ZZ->(dbSkip())
					Loop
				Endif
				_nValor := ZZ->VALTOT + ZZ->VALFRE
			ElseIf Alltrim(NEWCTS->CTS_CONTAG) = "3.03" // VENDA COM FRETE
				If LEFT(ZZ->PRODUTO,4) != "V005"
					ZZ->(dbSkip())
					Loop
				Endif
				_nValor := ZZ->VALTOT + ZZ->VALFRE
			ElseIf Alltrim(NEWCTS->CTS_CONTAG) = "3.04" // VENDA COM FRETE
				If LEFT(ZZ->PRODUTO,4) != "V003"
					ZZ->(dbSkip())
					Loop
				Endif
				_nValor := ZZ->VALTOT + ZZ->VALFRE
				
			ElseIf Alltrim(NEWCTS->CTS_CONTAG) = "3.05"// VENDA SEM FRETE
				If LEFT(ZZ->PRODUTO,4) != "V002"
					ZZ->(dbSkip())
					Loop
				Endif
				_nValor := ZZ->VALTOT
			ElseIf Alltrim(NEWCTS->CTS_CONTAG) = "3.06"
				If LEFT(ZZ->PRODUTO,4) != "V001"
					ZZ->(dbSkip())
					Loop
				Endif
				_nValor := ZZ->VALTOT
			ElseIf Alltrim(NEWCTS->CTS_CONTAG) = "3.07"
				If LEFT(ZZ->PRODUTO,4) != "V005"
					ZZ->(dbSkip())
					Loop
				Endif
				_nValor := ZZ->VALTOT
			ElseIf Alltrim(NEWCTS->CTS_CONTAG) = "3.08"
				If LEFT(ZZ->PRODUTO,4) != "V003"
					ZZ->(dbSkip())
					Loop
				Endif
				_nValor := ZZ->VALTOT
			ElseIf Alltrim(NEWCTS->CTS_CONTAG) = "4.01" // PIS
				_nValor := ZZ->VALPIS
			ElseIf Alltrim(NEWCTS->CTS_CONTAG) = "4.02" // COFINS
				_nValor := ZZ->VALCOF
			ElseIf Alltrim(NEWCTS->CTS_CONTAG) = "4.03" // ICMS
				_nValor := ZZ->VALICM
			Endif
			
			_cAnoMes:= ZZ->ANOMES
			_cSeek  := NEWCTS->CTS_FILIAL+NEWCTS->CTS_CODPLA+NEWCTS->CTS_LINHA+NEWCTS->CTS_CONTAG + _cANOMES
			
			If !TRB->(dbSeek(_cSeek))
				TRB->(RecLock("TRB",.T.))
				TRB->FILIAL	:= NEWCTS->CTS_FILIAL
				TRB->VISAO	:= NEWCTS->CTS_CODPLA
				TRB->LINHA	:= NEWCTS->CTS_LINHA
				TRB->ENTID	:= NEWCTS->CTS_CONTAG
				TRB->DESCR	:= NEWCTS->CTS_DESCCG
				TRB->PERIO  := _cAnoMes
				TRB->VALOR  := _nValor
				TRB->(MsUnLock())
			Else
				TRB->(RecLock("TRB",.F.))
				TRB->VALOR  += _nValor
				TRB->(MsUnLock())			
			Endif
			
			ZZ->(dbskip())
		EndDo

		ZZ2->(dbgotop())
		While ZZ2->(!Eof())
                                
			_nQuant   := 0
			_cUnidMed := "2" // 2 - SEGUNDA UNIDADE DE MEDIDA
			
			SB1->(dbSetOrder(1))
			If SB1->(dbSeek(xFilial("SB1") + ZZ2->PRODUTO))
				If !Empty(SB1->B1_SEGUM) .And. SB1->B1_CONV > 0
					SA7->(dbSetOrder(1))
					If SA7->(dbSeek(xFilial("SA7") + ZZ2->CLIENTE + ZZ2->LOJA + ZZ2->PRODUTO))
						_cUnidMed := SA7->A7_YTPVEND  // 1- PRIMEIRA UNIDADE DE MEDIDA
					Endif               
					     
					If _cUnidMed  == "1" .And. SB1->B1_UM <> "KG"
						If SB1->B1_TIPCONV == "M"
							_nQuant := (ZZ2->QUANT / SB1->B1_CONV)
						Else
							_nQuant := (ZZ2->QUANT * SB1->B1_CONV)
						Endif
					Else
						_nQuant := ZZ2->QUANT					
					Endif
				Else
					_nQuant := ZZ2->QUANT
				Endif
			Else                    				
				_nQuant := ZZ2->QUANT			           				
			Endif				

			If Alltrim(NEWCTS->CTS_CONTAG) = "2.01"
				If LEFT(ZZ2->PRODUTO,4) != "V002"
					ZZ2->(dbSkip())
					Loop
				Endif
				_nValor := _nQuant
			ElseIf Alltrim(NEWCTS->CTS_CONTAG) = "2.02"
				If LEFT(ZZ2->PRODUTO,4) != "V001"
					ZZ2->(dbSkip())   
					Loop
				Endif
				_nValor := _nQuant
			ElseIf Alltrim(NEWCTS->CTS_CONTAG) = "2.03"
				If LEFT(ZZ2->PRODUTO,4) != "V005"
					ZZ2->(dbSkip())
					Loop
				Endif
				_nValor := _nQuant
			ElseIf Alltrim(NEWCTS->CTS_CONTAG) = "2.04"
				If LEFT(ZZ2->PRODUTO,4) != "V003"
					ZZ2->(dbSkip())
					Loop
				Endif
				_nValor := _nQuant
			ElseIf Alltrim(NEWCTS->CTS_CONTAG) = "3.01" // VENDA COM FRETE
				If LEFT(ZZ2->PRODUTO,4) != "V002"
					ZZ2->(dbSkip())
					Loop
				Endif
				_nValor := ZZ2->VALTOT + ZZ2->VALFRE
			ElseIf Alltrim(NEWCTS->CTS_CONTAG) = "3.02" // VENDA COM FRETE
				If LEFT(ZZ2->PRODUTO,4) != "V001"
					ZZ2->(dbSkip())
					Loop
				Endif
				_nValor := ZZ2->VALTOT + ZZ2->VALFRE
			ElseIf Alltrim(NEWCTS->CTS_CONTAG) = "3.03" // VENDA COM FRETE
				If LEFT(ZZ2->PRODUTO,4) != "V005"
					ZZ2->(dbSkip())
					Loop
				Endif
				_nValor := ZZ2->VALTOT + ZZ2->VALFRE
			ElseIf Alltrim(NEWCTS->CTS_CONTAG) = "3.04" // VENDA COM FRETE
				If LEFT(ZZ2->PRODUTO,4) != "V003"
					ZZ2->(dbSkip())
					Loop
				Endif
				_nValor := ZZ2->VALTOT + ZZ2->VALFRE
				
			ElseIf Alltrim(NEWCTS->CTS_CONTAG) = "3.05"// VENDA SEM FRETE
				If LEFT(ZZ2->PRODUTO,4) != "V002"
					ZZ2->(dbSkip())
					Loop
				Endif
				_nValor := ZZ2->VALTOT
			ElseIf Alltrim(NEWCTS->CTS_CONTAG) = "3.06"
				If LEFT(ZZ2->PRODUTO,4) != "V001"
					ZZ2->(dbSkip())
					Loop
				Endif
				_nValor := ZZ2->VALTOT
			ElseIf Alltrim(NEWCTS->CTS_CONTAG) = "3.07"
				If LEFT(ZZ2->PRODUTO,4) != "V005"
					ZZ2->(dbSkip())
					Loop
				Endif
				_nValor := ZZ2->VALTOT
			ElseIf Alltrim(NEWCTS->CTS_CONTAG) = "3.08"
				If LEFT(ZZ2->PRODUTO,4) != "V003"
					ZZ2->(dbSkip())
					Loop
				Endif
				_nValor := ZZ2->VALTOT
			ElseIf Alltrim(NEWCTS->CTS_CONTAG) = "4.01" // PIS
				_nValor := ZZ2->VALPIS
			ElseIf Alltrim(NEWCTS->CTS_CONTAG) = "4.02" // COFINS
				_nValor := ZZ2->VALCOF
			ElseIf Alltrim(NEWCTS->CTS_CONTAG) = "4.03" // ICMS
				_nValor := ZZ2->VALICM
			Endif
			
			_cAnoMes:= ZZ2->ANOMES
			_cSeek  := NEWCTS->CTS_FILIAL+NEWCTS->CTS_CODPLA+NEWCTS->CTS_LINHA+NEWCTS->CTS_CONTAG + _cANOMES
			
			If !TRB->(dbSeek(_cSeek))
				TRB->(RecLock("TRB",.T.))
				TRB->FILIAL	:= NEWCTS->CTS_FILIAL
				TRB->VISAO	:= NEWCTS->CTS_CODPLA
				TRB->LINHA	:= NEWCTS->CTS_LINHA
				TRB->ENTID	:= NEWCTS->CTS_CONTAG
				TRB->DESCR	:= NEWCTS->CTS_DESCCG
				TRB->PERIO  := _cAnoMes
				TRB->VALOR  := (_nValor) * -1
				TRB->(MsUnLock())
			Else
				TRB->(RecLock("TRB",.F.))
				TRB->VALOR  += ((_nValor) * -1)
				TRB->(MsUnLock())			
			Endif
			
			ZZ2->(dbskip())
		EndDo		
		NEWCTS->(dbSKIP())
		Loop
	Endif
	/*
	If Empty(_cAnoMes)
		_cANOMES:= LEFT(DTOS(MV_PAR01),6)
	Endif
	
	_cSeek    := NEWCTS->CTS_FILIAL+NEWCTS->CTS_CODPLA+NEWCTS->CTS_LINHA+NEWCTS->CTS_CONTAG + _cANOMES
	
	If !TRB->(dbSeek(_cSeek))
		TRB->(RecLock("TRB",.T.))
		TRB->FILIAL	:= NEWCTS->CTS_FILIAL
		TRB->VISAO	:= NEWCTS->CTS_CODPLA
		TRB->LINHA	:= NEWCTS->CTS_LINHA
		TRB->ENTID	:= NEWCTS->CTS_CONTAG
		TRB->DESCR	:= NEWCTS->CTS_DESCCG
		TRB->PERIO  := _cAnoMes
		TRB->VALOR  := _nValor
		TRB->(MsUnlock())
	Endif
	*/
	NEWCTS->(dbSKIP())
EndDo

ZZ->(dbCloseArea()) 
ZZ2->(dbCloseArea())

TRB->(dbgoTop())

While TRB->(!EOF())
	
	SZ7->(dbSetorder(1))
	If SZ7->(dbSeek(xFilial("SZ7" ) + TRB->VISAO + TRB->LINHA + TRB->ENTID + TRB->PERIO ))
		SZ7->(RecLock("SZ7",.F.))
		SZ7->Z7_VALOR	 += TRB->VALOR
		SZ7->(MsUnLock())
	Else
		SZ7->(RecLock("SZ7",.T.))
		SZ7->Z7_FILIAL	 := xFilial("SZ7")
		SZ7->Z7_CODPLA	 := TRB->VISAO
		SZ7->Z7_ORDEM	 := TRB->LINHA
		SZ7->Z7_CONTAG	 := TRB->ENTID
		SZ7->Z7_DESCCG	 := TRB->DESCR
		SZ7->Z7_VALOR	 := TRB->VALOR
		SZ7->Z7_PERIODO  := TRB->PERIO
		SZ7->(MsUnLock())
	Endif
	
	TRB->(dbskip())
EndDo

TRB->(dbCloseArea())

NEWCTS->(dbCloseArea())

If cNomeArq # Nil
	Ferase(cNomeArq+OrdBagExt())
Endif

Return


Static Function PXH026D(_lFim)

Local nRegCT2   := CT2->(Recno())
Local nRegCTS   := CTS->(Recno())
Local aStru		 := CTS->(DbStruct()), nI
Local cQuery

Pergunte("PXH026",.F.)

_cAno1   := LEFT(DTOS(STOD(LEFT(DTOS(MV_PAR01),4)+"0101")-1),4)
_cAnoAnt := _cAno1 + "01"
_cAnoFim := _cAno1 + "12"

_cQ := " DELETE "+RetSqlName("SZ7")+" WHERE Z7_FILIAL = '"+xFilial("SZ7")+"' "
_cQ += " AND Z7_PERIODO BETWEEN  '"+_cAnoAnt+"' AND '"+_cAnoFim+"' AND Z7_CODPLA = '005' "
TCSQLEXEC(_cQ)

_cQ := " DELETE "+RetSqlName("SZ7")+" WHERE Z7_FILIAL = '"+xFilial("SZ7")+"' "
_cQ += " AND Z7_PERIODO BETWEEN '"+LEFT(DTOS(MV_PAR01),6)+"' AND '"+LEFT(DTOS(MV_PAR02),6)+"' AND Z7_CODPLA = '005' "
TCSQLEXEC(_cQ)

aCampos := {}

AADD(aCampos,{"FILIAL"	    ,"C" ,05,0	})
AADD(aCampos,{"VISAO"	    ,"C" ,03,0	})
AADD(aCampos,{"LINHA"	    ,"C" ,03,0	}) // LINHA CTS_LINHA
AADD(aCampos,{"ENTID"	    ,"C" ,20,0	})
AADD(aCampos,{"DESCR"	    ,"C" ,40,0	})
AADD(aCampos,{"PERIO"	    ,"C" ,06,0	})
AADD(aCampos,{"VALOR"	    ,"N" ,17,2	})
AADD(aCampos,{"DTMOV"	    ,"D" ,08,0	})

cArqTemp	:=	CriaTrab(aCampos)

dbUseArea(.T.,,cArqTemp,"TRB",.F.,.F.)

IndRegua("TRB",cArqTemp,"FILIAL+VISAO+LINHA+ENTID+PERIO",,,"Indexando Dados")

_dFirstD  := FirstDay(MV_PAR01)
_dLastD   := LastDay(MV_PAR02)

_cVisao   := "('005')"

_cProd    := Alltrim(GetMv("PXH_PRDDRE"))  // PRODUTOS DO OURO
_cProduto := "('"

For Ax:= 1 To Len(_cProd)
	If Substr(_cProd,AX,1) != "*"
		_cProduto += Substr(_cProd,AX,1)
	Else
		_cProduto += "','"
	Endif
Next AX

_cProduto += "')"

_cANOMES:= LEFT(DTOS(MV_PAR01),6)

// Obtem os registros a serem processados

cQuery := " SELECT * FROM "+RetSqlName("CTS")+" CTS "
cQuery += " WHERE CTS.D_E_L_E_T_ = '' AND CTS_CODPLA IN "+_cVisao+" "
cQuery += " AND CTS_FILIAL = '"+xFilial("CTS")+"' "
cQuery += " ORDER BY CTS_CODPLA,CTS_ORDEM "

TCQUERY cQuery NEW ALIAS "NEWCTS"

For nI := 1 TO LEN(aStru)
	If aStru[nI][2] != "C"
		TCSetField("NEWCTS", aStru[nI][1], aStru[nI][2], aStru[nI][3], aStru[nI][4])
	EndIf
Next

cNomeArq := CriaTrab(Nil,.F.)
IndRegua("NEWCTS",cNomeArq,"CTS_FILIAL+CTS_CODPLA+CTS_ORDEM",,,"Selecionando Registros...")

If cEmpAnt == "06"
	_cQ := " SELECT Z8_ANOMES AS ANOMES,Z8_AUACUM AS AUACUM, Z8_TOTTON AS TOTTON,Z8_DTMOV,Z8_PRODDIA, Z8_QTAUFIN FROM "+RetSqlName("SZ8")+" A "
	_cQ += " WHERE A.D_E_L_E_T_ = '' AND Z8_CODFIL = '"+cFilAnt+"' "
	_cQ += " AND Z8_ANOMES = '"+_cANOMES+"' "
	_cQ += " ORDER BY Z8_ANOMES,Z8_ITEM,Z8_DTMOV "
	
	TCQUERY _cQ NEW ALIAS "ZZ"
	
	TCSETFIELD("ZZ","AUACUM"  ,"N",17,2)
	TCSETFIELD("ZZ","TOTTON"  ,"N",17,2)
	TCSETFIELD("ZZ","Z8_DTMOV","D",08)
	
	NEWCTS->(dbGoTop())
	
	ProcRegua(NEWCTS->(LASTREC()))
	
	_cANOMES  := LEFT(DTOS(MV_PAR01),6)
	_nQtAuFin := 0
	
	While NEWCTS->(!Eof())
		
		IncProc()
		
		_lAntZero := .F.
		
		If Alltrim(NEWCTS->CTS_CONTAG)     == "1.1"
			_nValor := ZZ->AUACUM
		Elseif Alltrim(NEWCTS->CTS_CONTAG) == "1.2"
			_nValor := ZZ->TOTTON
		Elseif Alltrim(NEWCTS->CTS_CONTAG) == "1.3"
			
			_cQ := " SELECT * FROM "+RetSqlName("SRA")+" A "
			_cQ += " WHERE A.D_E_L_E_T_ = '' AND RA_FILIAL = '"+xFilial("SRA")+"' AND RA_CATFUNC <> 'A' "
			_cQ += " ORDER BY RA_MAT "
			
			TCQUERY _cq NEW ALIAS "ZRA"
			
			TCSETFIELD("ZRA","RA_DEMISSA" ,"D",08)
			
			ZRA->(dbGotop())
			
			_nCont := 0
			
			While ZRA->(!Eof())
				
				If !Empty(ZRA->RA_DEMISSA ) .And. ZRA->RA_DEMISSA < _dFirstD  //> _dLastD
					ZRA->(dbSkip())
					Loop
				Endif
				
				_nCont++
				
				ZRA->(dbSkip())
			EndDo
			
			ZRA->(dbCloseArea())
			
			_nValor := _nCont
			
		ElseIf Alltrim(NEWCTS->CTS_CONTAG) == "1.4"
			ZZ->(dbGotop())
			
			_nDiaTrab := 0
			_nDiaUtil := 0
			_dDtAtual := CTOD("")
			_lAntZero := .F.
			
			While ZZ->(!Eof())
				
				_nDiaUtil ++
				_nQtAuFin += ZZ->Z8_QTAUFIN
				
				If ZZ->Z8_PRODDIA == 0
					_lAntZero := .T.
				ElseIf ZZ->Z8_PRODDIA > 0
					If _lAntZero
						_nDiaTrab ++
					Endif
					
					_dDtAtual := ZZ->Z8_DTMOV
					_nDiaTrab ++
					
					_lAntZero := .f.
				Endif
				
				ZZ->(dbSkip())
			EndDo
		Endif
		
		If Alltrim(NEWCTS->CTS_CONTAG)     == "1.4"
			_nValor := _nDiaTrab
		ElseIf Alltrim(NEWCTS->CTS_CONTAG) == "1.5"
			_nValor := _nDiaUtil
		ElseIf Alltrim(NEWCTS->CTS_CONTAG) == "1.6"
			_nValor := 0
		ElseIf Alltrim(NEWCTS->CTS_CONTAG) == "1.7"
			_nValor := _nQtAuFin
		Endif
		
		_cSeek  := NEWCTS->CTS_FILIAL+NEWCTS->CTS_CODPLA+NEWCTS->CTS_LINHA+NEWCTS->CTS_CONTAG + _cANOMES
		
		If !TRB->(dbSeek(_cSeek))
			TRB->(RecLock("TRB",.T.))
			TRB->FILIAL	:= NEWCTS->CTS_FILIAL
			TRB->VISAO	:= NEWCTS->CTS_CODPLA
			TRB->LINHA	:= NEWCTS->CTS_LINHA
			TRB->ENTID	:= NEWCTS->CTS_CONTAG
			TRB->DESCR	:= NEWCTS->CTS_DESCCG
			TRB->PERIO  := _cAnoMes
			TRB->VALOR  := _nValor
			If Alltrim(NEWCTS->CTS_CONTAG) == "1.6"
				TRB->DTMOV  := _dDtAtual
			Endif
			TRB->(MsUnlock())
		Endif
		
		NEWCTS->(dbSKIP())
	EndDo
	
	ZZ->(dbCloseArea())
Endif

TRB->(dbgoTop())

While TRB->(!EOF())
	
	SZ7->(dbSetorder(1))
	If SZ7->(dbSeek(xFilial("SZ7" ) + TRB->VISAO + TRB->LINHA + TRB->ENTID + TRB->PERIO ))
		SZ7->(RecLock("SZ7",.F.))
		SZ7->Z7_VALOR	 += TRB->VALOR
		SZ7->(MsUnLock())
	Else
		SZ7->(RecLock("SZ7",.T.))
		SZ7->Z7_FILIAL	 := xFilial("SZ7")
		SZ7->Z7_CODPLA	 := TRB->VISAO
		SZ7->Z7_ORDEM	 := TRB->LINHA
		SZ7->Z7_CONTAG	 := TRB->ENTID
		SZ7->Z7_DESCCG	 := TRB->DESCR
		SZ7->Z7_VALOR	 := TRB->VALOR
		SZ7->Z7_PERIODO  := TRB->PERIO
		SZ7->Z7_DATA     := TRB->DTMOV
		SZ7->(MsUnLock())
	Endif
	
	TRB->(dbskip())
EndDo

TRB->(dbCloseArea())

NEWCTS->(dbCloseArea())

If cNomeArq # Nil
	Ferase(cNomeArq+OrdBagExt())
Endif

Return

Static Function AtuSX1()

cPerg := "PXH026"
aRegs := {}

//    	   Grupo/Ordem/Pergunta      /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid          /Var01     /Def01             /defspa1/defeng1/Cnt01/Var02/Def02            /Defspa2/defeng2/Cnt02/Var03/Def03/defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
U_CRIASX1(cPerg,"01","Data De       ?",""       ,""      ,"mv_ch1","D" ,08     ,0      ,0     ,"G",""            ,"MV_PAR01",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"02","Data Ate      ?",""       ,""      ,"mv_ch2","D" ,08     ,0      ,0     ,"G",""            ,"MV_PAR02",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")

Return