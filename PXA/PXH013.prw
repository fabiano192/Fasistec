#include "rwmake.ch"
#include "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ PXH013 ³ Autor ³SANDE                    ³ Data ³ 26.12.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Rotina de Limpeza de Flags Contabeis                       ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGACTB                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function PXH013()

SetPrvt("CONTEM,IND,I,CINDICE,CARQUIVO,lCondicao")

cPerg := "PXH013"

ATUSX1()

If !Pergunte("PXH013",.T.)
	Return
EndIf

Processa({|| LimpaSQL()})

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
Local cEOL := Chr(13)

Local dData1 := mv_par01
Local dData2 := mv_par02
Local nMod   := mv_par03 // MODULOS 1-receber 2-pagar 3-faturamento 4-compras 5-Caixa / Fatura
Local cDoc   := SPACE(09)//mv_par04
Local cSerie := SPACE(03)//mv_par05
Local cCliFor:= SPACE(06)//mv_par06
local cLoja  := SPACE(02)//mv_par07

If nMod == 1 // FINANCEIRO
	
	_dDtFec := GETMV("MV_DATAFIN")
	
	If MV_PAR01 <= _dDtFec
		MSGINFO(" Periodo Fechado (MV_DATAFIN)!!")
		Return
	Endif
	
	//If MV_PAR08 == 1 .Or. MV_PAR08 == 5
		
		_cQuery := " UPDATE "+RetSqlName("SE2")+" SET E2_LA = '' "
		_cQuery += " WHERE E2_EMIS1 BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'
		_cQuery += " AND E2_FILIAL = '"+xFilial("SE2")+"' AND E2_ORIGEM NOT IN ('MATA460','MATA100') "
		
		TcSQLExec(_cQuery)
		
		IncProc()
		
		_cQuery := " UPDATE "+RetSqlName("SE1")+" SET E1_LA = '' "
		_cQuery += " WHERE E1_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'
		_cQuery += " AND E1_FILIAL = '"+xFilial("SE1")+"' AND E1_ORIGEM NOT IN ('MATA460','MATA100') "
		
		TcSQLExec(_cQuery)
		
		IncProc()
		
		_cQuery := " UPDATE "+RetSqlName("SE5")+" SET E5_LA = '' "
		_cQuery += " WHERE E5_DTDISPO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'
		_cQuery += " AND E5_FILIAL = '"+xFilial("SE5")+"' "
		
		TcSQLExec(_cQuery)
		
		_cQuery := " UPDATE "+RetSqlName("SEF")+" SET EF_LA = '' "
		_cQuery += " WHERE EF_DATA  BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'
		_cQuery += " AND EF_FILIAL = '"+xFilial("SEF")+"' "
		
		TcSQLExec(_cQuery)
	//Endif
	
	//If MV_PAR08 == 2 .Or. MV_PAR08 == 5
		
		_cQuery := " UPDATE "+RetSqlName("SEU")+" SET EU_LA = '' "
		_cQuery += " WHERE EU_DTDIGIT BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'
		_cQuery += " AND EU_FILIAL = '"+xFilial("SEU")+"' "
		
		TcSQLExec(_cQuery)
			
	//Endif
	
	//If MV_PAR08 == 3 .Or. MV_PAR08 == 5
		
		_cQuery := " UPDATE "+RetSqlName("SE1")+" SET E1_LA = '' "
		_cQuery += " WHERE E1_DTFATUR BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'
		_cQuery += " AND E1_FILIAL = '"+xFilial("SE1")+"' "//AND E1_ORIGEM NOT IN ('MATA460','MATA100') "
		
		TcSQLExec(_cQuery)
		
		IncProc()
		
		_cQuery := " UPDATE "+RetSqlName("SE2")+" SET E2_LA = '' "
		_cQuery += " WHERE E2_DTFATUR BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'
		_cQuery += " AND E2_FILIAL = '"+xFilial("SE2")+"' "//AND E2_ORIGEM NOT IN ('MATA460','MATA100') "
		
		TcSQLExec(_cQuery)
		
		IncProc()
		
	//Endif
	
	//If MV_PAR08 == 4 .Or. MV_PAR08 == 5
		
		_cQuery    := " UPDATE "+RetSqlName("SE5")+" A SET E5_LA = '' "
		_cQuery    += " WHERE A.D_E_L_E_T_ = '' AND E5_DTDISPO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
		_cQuery    += " AND E5_MOTBX = 'CEC'"
		
		TcSQLExec(_cQuery)
		
		IncProc()
	//Endif
Endif


If nMod == 2 // FATURAMENTO
	
	_dDtFec := GETMV("MV_DATAFIS")
	
	If MV_PAR01 <= _dDtFec
		MSGINFO(" Periodo Fechado (MV_DATAFIS)!!")
		Return
	Endif
	
	cSQL := "UPDATE "+cSF2+cEOL
	cSQL += " SET F2_DTLANC = ' ' WHERE F2_FILIAL = "+ValToSql(xFilial("SF2"))+cEOL
	cSQL += " AND F2_EMISSAO BETWEEN "+Valtosql(dData1)+" AND "+Valtosql(dData2)+cEOL
	//If !Empty(cDoc) .And. !Empty(cSerie)
	//	cSQL += " AND F2_SERIE = "+ValtoSql(cSerie)+cEOL
	//	cSQL += " AND F2_DOC = "+Valtosql(cDoc)+cEOL
	//ndIf
	//If !Empty(cCliFor) .And. !Empty(cLoja)
	//	cSQL += " AND F2_CLIENTE = "+Valtosql(cCliFor)+cEOL
	//	cSQL += " AND F2_LOJA ="+Valtosql(cLoja)+cEOL
	//EndIF
	cSQL += " AND D_E_L_E_T_ = ' '"
	
	TcSqlExec(cSQL)
EndIf

If nMod == 3  // COMPRAS
	
	_dDtFec := GETMV("MV_DATAFIS")
	
	If MV_PAR01 <= _dDtFec
		MSGINFO(" Periodo Fechado (MV_DATAFIS)!!")
		Return
	Endif
	
	cSQL := "UPDATE "+cSF1+cEOL
	cSQL += " SET F1_DTLANC = ' ' WHERE F1_FILIAL = "+ValToSql(xFilial("SF1"))+cEOL
	cSQL += " AND F1_DTDIGIT BETWEEN "+Valtosql(dData1)+" AND "+Valtosql(dData2)+cEOL
	cSQL += " AND D_E_L_E_T_ = ' '"
	//If !Empty(cDoc) .And. !Empty(cSerie)
	//	cSQL += " AND F1_SERIE = "+ValtoSql(cSerie)+cEOL
	//	cSQL += " AND F1_DOC = "+Valtosql(cDoc)+cEOL
	//EndIf
	//If !Empty(cCliFor) .And. !Empty(cLoja)
	//	cSQL += " AND F1_FORNECE = "+Valtosql(cCliFor)+cEOL
	//	cSQL += " AND F1_LOJA ="+Valtosql(cLoja)+cEOL
	//EndIF
	
	TcSqlExec(cSQL)
EndIf

If nMod == 4 // CUSTOS
	
	_cq := " UPDATE "+RetSqlName("SF1")+" SET F1_DTLANC = '' FROM "+RetSqlName("SF1")+" A INNER JOIN "+RetSqlName("SD1")+" B "
	_cq += " ON F1_FILIAL=D1_FILIAL AND F1_DOC=D1_DOC AND F1_SERIE=D1_SERIE AND D1_FORNECE=F1_FORNECE AND D1_LOJA=F1_LOJA    "
	_cQ += " WHERE D1_DTDIGIT BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'	AND D1_TES = '222' AND A.D_E_L_E_T_ = ''  "
	_cq += " AND B.D_E_L_E_T_ = '' "
	
	TcSqlExec(_cQ)
EndIf

Return


Static Function ATUSX1()

cPerg := "PXH013"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ mv_par01 -> Data De                                                 ³
//³ mv_par02 -> Data Ate                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//    	   Grupo/Ordem/Pergunta               /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid          /Var01     /Def01     /defspa1/defeng1/Cnt01/Var02/Def02         /Defspa2/defeng2/Cnt02/Var03/Def03    /defspa3/defeng3/Cnt03/Var04/Def04   /defspa4/defeng4/Cnt04/Var05/Def05         /deefspa5/defeng5/Cnt05/F3
U_CRIASX1(cPerg,"01","Data De              	   ?",""       ,""      ,"mv_ch1","D" ,08     ,0      ,0     ,"G",""        ,"MV_PAR01","       "   ,""     ,""     ,""   ,""   ,"           " ,""     ,""     ,""   ,""   ,""       ,""     ,""     ,""   ,""   ,""      ,""     ,""     ,""   ,""   ,""            ,""      ,""     ,""  ,"")
U_CRIASX1(cPerg,"02","Data Ate             	   ?",""       ,""      ,"mv_ch2","D" ,08     ,0      ,0     ,"G",""        ,"MV_PAR02","       "   ,""     ,""     ,""   ,""   ,"           " ,""     ,""     ,""   ,""   ,""       ,""     ,""     ,""   ,""   ,""      ,""     ,""     ,""   ,""   ,""            ,""      ,""     ,""  ,"")
U_CRIASX1(cPerg,"03","Modulos              	   ?",""       ,""      ,"mv_ch3","C" ,01     ,0      ,0     ,"C",""        ,"MV_PAR03","Financeiro",""     ,""     ,""   ,""   ,"Faturamento" ,""     ,""     ,""   ,""   ,"Compras",""     ,""     ,""   ,""   ,"Custos",""     ,""     ,""   ,""   ,"Caixa/Fatura",""      ,""     ,""  ,"")

Return