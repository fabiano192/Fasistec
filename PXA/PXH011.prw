#include "rwmake.ch"
#include "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ LIMPA  ³ Autor ³SANDE                    ³ Data ³ 26.12.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Rotina de Limpeza de Flags Contabeis                       ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGACTB                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PXH011()

local _enter:= chr(13)+chr(10)
SetPrvt("CONTEM,IND,I,CINDICE,CARQUIVO,lCondicao")


cmens:= 'Help: Campo - LOTE: ' +_enter
cmens+= ' a) se estiver preenchido, seram deletados os lotes iguais ao informado '+_enter
cmens+= ' b) se em branco, será considerado o numero do lote padrao do sistema para o modulo escolhido '+_enter

alert(cmens)


cPerg := PADR("PXH011",10)
ValPerg(cPerg)

If !Pergunte(cperg,.T.)
	Return
EndIf

Processa({|| LimpaSQL() } , "Descontabilizando movim. entre "+dtoc(mv_par01)+" e "+dtoc(mv_par02)  )

Return

//Processa({|| RptDetail()})
Return



Static Function LimpaSQL

Local cSQL := ""
Local aTab := {}

Local cSE1 := RetSqlName("SE1")
Local cSE2 := RetSqlName("SE2")
Local cSE5 := RetSqlName("SE5")
Local cSEF := RetSqlName("SEF")
Local cSF1 := RetSqlName("SF1")
Local cSF2 := RetSqlName("SF2")
Local cCT2 := RetSqlName("CT2")
Local cEOL := Chr(13)

Local dData1 := mv_par01
Local dData2 := mv_par02
Local nMod   := mv_par03 // MODULOS 1-receber 2-pagar 3-faturamento 4-compras 5-todos
Local cDoc   := mv_par04
Local cSerie := mv_par05
Local cCliFor:= mv_par06
Local cLoja  := mv_par07
Local cLote  := mv_par08
Local cDocCTB:= mv_par09
Local nSteps :=0

// CONTAS A RECEBER
If nMod == 1 .Or. nMod == 5
	
	cLote:= iif( empty(cLote), strzero( val( tabela('09','FIN') ),6) , cLote )
	
	cSQL := "UPDATE "+cSE1+cEOL
	cSQL += " SET E1_LA = ' ' "+cEOL
	cSQL += " WHERE E1_FILIAL = "+ValToSql(xFilial("SE1"))+cEOL
	cSQL += " AND E1_EMISSAO BETWEEN "+Valtosql(dData1)+" AND "+Valtosql(dData2)+cEOL
	cSQL += " OR  E1_BAIXA BETWEEN "+Valtosql(dData1)  +" AND "+Valtosql(dData2)+cEOL
	If !Empty(cDoc) .And. !Empty(cSerie)
		cSQL += " AND E1_PREFIXO = "+ValtoSql(cSerie)+cEOL
		cSQL += " AND E1_NUM = "+Valtosql(cDoc)+cEOL
	EndIf
	If !Empty(cCliFor) .And. !Empty(cLoja)
		cSQL += " AND E1_CLIENTE = "+Valtosql(cCliFor)+cEOL
		cSQL += " AND E1_LOJA ="+Valtosql(cLoja)+cEOL
	EndIF
	cSQL += " AND D_E_L_E_T_ = ' '"
	TcSqlExec(cSQL)
	nSteps++
EndIf

// CONTAS A PAGAR
If nMod == 2 .Or. nMod == 5
	
	cLote:= iif( empty(cLote), strzero( val( tabela('09','FIN') ),6) , cLote )
	
	cSQL := "UPDATE "+cSE2+cEOL
	cSQL += " SET E2_LA = ' ' WHERE E2_FILIAL = "+ValToSql(xFilial("SE2"))+cEOL
	cSQL += " AND E2_EMISSAO BETWEEN "+Valtosql(dData1)+" AND "+Valtosql(dData2)+cEOL
	cSQL += " OR  E2_BAIXA BETWEEN "+Valtosql(dData1)+" AND "+Valtosql(dData2)+cEOL
	If !Empty(cDoc) .And. !Empty(cSerie)
		cSQL += " AND E2_PREFIXO = "+ValtoSql(cSerie)+cEOL
		cSQL += " AND E2_NUM = "+Valtosql(cDoc)+cEOL
	EndIf
	If !Empty(cCliFor) .And. !Empty(cLoja)
		cSQL += " AND E2_FORNECE = "+Valtosql(cCliFor)+cEOL
		cSQL += " AND E2_LOJA ="+Valtosql(cLoja)+cEOL
	EndIF
	cSQL += " AND D_E_L_E_T_ = ' '"
	TcSqlExec(cSQL)
	nSteps++
EndIf

// CONTAS A PAGAR / RECEBER
If nMod == 1 .Or. nMod == 2 .Or. nMod == 5
	//CONTAS A PAGAR - DATA DE PAGAMENTO
	cLote:= iif( empty(cLote), strzero( val( tabela('09','FIN') ),6) , cLote )
	
	cSQL := "UPDATE "+cSE5+cEOL
	cSQL += " SET E5_LA = ' ' WHERE E5_FILIAL = "+ValToSql(xFilial("SE5"))+cEOL
	cSQL += " AND E5_DATA    BETWEEN "+Valtosql(dData1)+" AND "+Valtosql(dData2)+cEOL
	cSQL += " AND D_E_L_E_T_ = ' '"
	cSQL += " AND E5_RECPAG = 'P' "
	If !Empty(cDoc) .And. !Empty(cSerie)
		cSQL += " AND E5_PREFIXO = "+ValtoSql(cSerie)+cEOL
		cSQL += " AND E5_NUMERO = "+Valtosql(cDoc)+cEOL
	EndIf
	If !Empty(cCliFor) .And. !Empty(cLoja)
		cSQL += " AND E5_CLIFOR = "+Valtosql(cCliFor)+cEOL
		cSQL += " AND E5_LOJA ="+Valtosql(cLoja)+cEOL
	EndIF
	TcSqlExec(cSQL)
	nSteps++		
	
	//CONTAS A RECEBER - DATA DE DISPONIBILIDADE
	cSQL := "UPDATE "+cSE5+cEOL
	cSQL += " SET E5_LA = ' ' WHERE E5_FILIAL = "+ValToSql(xFilial("SE5"))+cEOL
	cSQL += " AND E5_DTDISPO    BETWEEN "+Valtosql(dData1)+" AND "+Valtosql(dData2)+cEOL
	cSQL += " AND E5_RECPAG = 'R' "
	cSQL += " AND D_E_L_E_T_ = ' '"
	If !Empty(cDoc) .And. !Empty(cSerie)
		cSQL += " AND E5_PREFIXO = "+ValtoSql(cSerie)+cEOL
		cSQL += " AND E5_NUMERO = "+Valtosql(cDoc)+cEOL
	EndIf
	If !Empty(cCliFor) .And. !Empty(cLoja)
		cSQL += " AND E5_CLIFOR = "+Valtosql(cCliFor)+cEOL
		cSQL += " AND E5_LOJA ="+Valtosql(cLoja)+cEOL
	EndIF
	TcSqlExec(cSQL)
	nSteps++
	
EndIf

// CHEQUES
If nMod <= 3 .Or. nMod == 5
	
	cLote:= iif( empty(cLote), strzero( val( tabela('09','FIN') ),6) , cLote )
	
	cSQL := "UPDATE "+cSEF+cEOL
	cSQL += " SET EF_LA = ' ' WHERE EF_FILIAL = "+ValToSql(xFilial("SEF"))+cEOL
	cSQL += " AND EF_DATA    BETWEEN "+Valtosql(dData1)+" AND "+Valtosql(dData2)+cEOL
	If !Empty(cDoc) .And. !Empty(cSerie)
		cSQL += " AND EF_PREFIXO = "+ValtoSql(cSerie)+cEOL
		cSQL += " AND EF_TITULO = "+Valtosql(cDoc)+cEOL
	EndIf
	If !Empty(cCliFor) .And. !Empty(cLoja)
		cSQL += " AND (EF_FORNECE = "+Valtosql(cCliFor)+cEOL
		cSQL += " AND EF_LOJA ="+Valtosql(cLoja)+cEOL
		cSQL += " ) OR (EF_CLIENTE = "+Valtosql(cCliFor)+cEOL
		cSQL += " AND EF_LOJACLI ="+Valtosql(cLoja)+cEOL
		cSQL += ")"
	EndIF
	cSQL += " AND D_E_L_E_T_ = ' '"
	TcSqlExec(cSQL)
	nSteps++
EndIf

// FATURAMENTO
If nMod == 3 .Or. nMod == 5
	
	cLote:= iif( empty(cLote), strzero( val( tabela('09','FAT') ),6) , cLote )
	
	cSQL := "UPDATE "+cSF2+cEOL
	cSQL += " SET F2_DTLANC = ' ' WHERE F2_FILIAL = "+ValToSql(xFilial("SF2"))+cEOL
	cSQL += " AND F2_EMISSAO BETWEEN "+Valtosql(dData1)+" AND "+Valtosql(dData2)+cEOL
	If !Empty(cDoc) .And. !Empty(cSerie)
		cSQL += " AND F2_SERIE = "+ValtoSql(cSerie)+cEOL
		cSQL += " AND F2_DOC = "+Valtosql(cDoc)+cEOL
	EndIf
	If !Empty(cCliFor) .And. !Empty(cLoja)
		cSQL += " AND F2_CLIENTE = "+Valtosql(cCliFor)+cEOL
		cSQL += " AND F2_LOJA ="+Valtosql(cLoja)+cEOL
	EndIF
	cSQL += " AND D_E_L_E_T_ = ' '"
	TcSqlExec(cSQL)
	nSteps++
EndIf

// COMPRAS
If nMod == 4 .Or. nMod == 5
	
	cLote:= iif( empty(cLote), strzero( val( tabela('09','COM') ),6) , cLote )
	
	cSQL := "UPDATE "+cSF1+cEOL
	cSQL += " SET F1_DTLANC = ' ' WHERE F1_FILIAL = "+ValToSql(xFilial("SF1"))+cEOL
	cSQL += " AND F1_DTDIGIT BETWEEN "+Valtosql(dData1)+" AND "+Valtosql(dData2)+cEOL
	cSQL += " AND D_E_L_E_T_ = ' '"
	If !Empty(cDoc) .And. !Empty(cSerie)
		cSQL += " AND F1_SERIE = "+ValtoSql(cSerie)+cEOL
		cSQL += " AND F1_DOC = "+Valtosql(cDoc)+cEOL
	EndIf
	If !Empty(cCliFor) .And. !Empty(cLoja)
		cSQL += " AND F1_FORNECE = "+Valtosql(cCliFor)+cEOL
		cSQL += " AND F1_LOJA ="+Valtosql(cLoja)+cEOL
	EndIF
	TcSqlExec(cSQL)
	nSteps++
EndIf


// PRE-LANCAMENTOS
If nSteps>0
	cSQL := "UPDATE "+cCT2+cEOL
	cSQL += " SET D_E_L_E_T_ = '*' "+cEOL
	cSQL += " WHERE CT2_FILIAL = "+ValToSql(xFilial("CT2"))+cEOL
	//cSQL += " AND CT2_FILORI  = "+ValToSql(xFilial(""))+cEOL
	cSQL += " AND CT2_DATA BETWEEN "+Valtosql(dData1)+" AND "+Valtosql(dData2)+cEOL
	cSQL += " AND D_E_L_E_T_ = ' '"
	If !Empty(cDocCTB)
		cSQL += " AND CT2_DOC = "+Valtosql(cDocCTB)+cEOL
	EndIf
	If !Empty(cLote) .and. nMod<5
		cSQL += " AND CT2_LOTE = "+Valtosql(cLote)+cEOL
	EndIf
	
	TcSqlExec(cSQL)
EndIf

Return


Static Function ValPerg(cPerg)

aRegs :={}
cPerg := PADR(cPerg,10)
aAdd(aRegs,{cPerg,"01","Data de              ?",".",".","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Data Ate             ?",".",".","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Modulos              ?",".",".","mv_ch2","N",01,0,0,"C","","mv_par03","Receber","","","","","Pagar","","","","","Faturamento","","","","","Compras","","","","","Todos","","","","",""})
aadd(aRegs,{cPerg,"04","Doc.Financeiro       ?",".",".","mv_ch4","C",06,0,0,"C","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"05","Serie/Prefixo        ?",".",".","mv_ch5","C",03,0,0,"C","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"06","Cliente/Fornecedor   ?",".",".","mv_ch6","C",06,0,0,"C","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"07","Loja                 ?",".",".","mv_ch7","C",02,0,0,"C","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"08","Lote                 ?",".",".","mv_ch8","C",06,0,0,"C","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"09","Doc.Lanc.Contabil    ?",".",".","mv_ch9","C",06,0,0,"C","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"10","Tipo de Saldo        ?",".",".","mv_chA","N",01,0,0,"C","","mv_par10","Real","","","","","Pre-Lanc.","","","","","Ambos","","","","","","","","","","","","","","",""})

dbSelectArea("SX1")
For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

Return