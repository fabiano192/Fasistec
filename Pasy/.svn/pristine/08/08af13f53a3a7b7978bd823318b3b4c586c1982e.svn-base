#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"

/*/
Função		:	MX0001
Autor		:	Fabiano da Silva
Data 		: 	20.04.2012
Descrição	: 	Relatório Pedido de Compras
/*/

User Function MX0001()

Local   oReport

Private _dFirstD,_dLastD
Private aRet    := {}
Private _aMes
Private cPerg   := "MX0001"
Private oPen
Private oFont,oFont1, oFont2, oFont3, oFont4, oFont5

ATUSX1()

oReport := MX001A()
oReport:PrintDialog()

Return


Static Function MX001A()

Local   oSection
Local   oCell
Private oReport

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³                                                                        ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport := TReport():New("MX0001","Pedido de Compras","MX0001", {|oReport| MX001B(oReport)},"Este programa tem como objetivo imprimir o Pedido de Compras.")

oReport:nLeftMargin  := 5.5
oReport:nLineHeight  := 50

oReport:cFontBody := 'Arial'
oReport:nFontBody := 07
oReport:lBold     := .T.

//oReport:oFontBody := TFont():New( "Arial",,07,,.T.,,,,,.f. )

//oFont   := TFont():New( "Arial",,nHeight,,lBold,,,,,lUnderLine )
oFont     := TFont():New( "Arial",,15,,.T.,,,,,.f. )
oFont1    := TFont():New( "Arial",,10,,.F.,,,,,.f. )
oFont2    := TFont():New( "Arial",,10,,.T.,,,,,.f. )
oFont3    := TFont():New( "Arial",,14,,.F.,,,,,.f. )
oFont4    := TFont():New( "Arial",,14,,.T.,,,,,.f. )
oFont5    := TFont():New( "Arial",,12,,.F.,,,,,.f. )

Pergunte("MX0001",.T.)

oReport:HideParamPage() //Não Imprime os Parâmetros
oReport:SetPortrait()

oPedido := TRSection():New(oReport,"Pedido de Compras",{"SC7"})

TRCell():New(oPedido,"IT"		,, "IT"	  		,,TamSx3("C7_ITEM")[1]    	, .F.)
TRCell():New(oPedido,"ITEM"		,, "ITEM" 		,,TamSx3("C7_PRODUTO")[1]	, .F.)
TRCell():New(oPedido,"QTDE"		,, "QUANTIDADE"	,,TamSx3("C7_QUANT")[1]		,/*[lPixel]*/,,"RIGHT",,"RIGHT")
TRCell():New(oPedido,"UM"		,, "UNID"		,,TamSx3("C7_UM")[1]		, .F.)
//TRCell():New(oPedido,"DESCRIC"	,, "DESCRIÇÃO"	,,TamSx3("C7_DESCRI")[1]	, .F.)
TRCell():New(oPedido,"DESCRIC"	,, "DESCRIÇÃO"	,,25	, .F.)
TRCell():New(oPedido,"UNIT"		,, "VR.UNITÁRIO",,TamSx3("C7_PRECO")[1]		,/*[lPixel]*/,,"RIGHT",,"RIGHT")
TRCell():New(oPedido,"TOTAL"	,, "VALOR TOTAL",,TamSx3("C7_TOTAL")[1]		,/*[lPixel]*/,,"RIGHT",,"RIGHT")
TRCell():New(oPedido,"IPI"		,, "IPI"		,,TamSx3("C7_IPI")[1]		,/*[lPixel]*/,,"RIGHT",,"RIGHT")
TRCell():New(oPedido,"ENTREGA"	,, "ENTREGA"	,,TamSx3("C7_DATPRF")[1]		, .F.)

oPedido:SetNoFilter({"SC7"})

Return(oReport)



Static Function MX001B(oReport)

Local oPedido	:= oReport:Section(1)
Local cTitulo 	:= ""
Local aRelat	:={}
Local nI        := 1
Local nRegSC7   := SC7->(Recno())

Private cNomeArq
//Private oPen    := TPen():New(0,5,CLR_BLACK)
oPen    := TPen():New(,7,CLR_BLACK)

cFilterUser := ""

cTitulo := "PEDIDO DE COMPRAS"

/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³aRelat[x][01]: IT
//³         [02]: ITEM
//³         [03]: QUANTIDADE
//³         [04]: UNID
//³         [05]: DESCRIÇÃO
//³         [06]: VR.UNITÁRIO
//³         [07]: VALOR TOTAL
//³         [08]: IPI
//³         [09]: ENTREGA
//³         [10]: NUMERO
//³         [11]: OBS
//³         [12]: FORNECEDOR
//³         [13]: CONTATO
//³         [14]: TEL 1
//³         [15]: TEL 2
//³         [16]: ENDERECO
//³         [17]: MUNICIPIO
//³         [18]: UF
//³         [19]: CEP
//³         [20]: CNPJ
//³         [21]: IE
//³         [22]: EMISSAO
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/

aRelat := PV001C(oReport)

If Len(aRelat) = 0
	Return Nil
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Metodo TrPosition()                                                     ³
//³                                                                        ³
//³Posiciona em um registro de uma outra tabela. O posicionamento será     ³
//³realizado antes da impressao de cada linha do relatório.                ³
//³                                                                        ³
//³ExpO1 : Objeto Report da Secao                                          ³
//³ExpC2 : Alias da Tabela                                                 ³
//³ExpX3 : Ordem ou NickName de pesquisa                                   ³
//³ExpX4 : String ou Bloco de código para pesquisa. A string será macroexe-³
//³        cutada.                                                         ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//TRPosition():New(oPedido,"CTS",1,{|| xFilial("CTS") + "003"})

oReport:HideHeader()
oReport:HideFooter()

oPedido:Cell("IT")			:SetBlock( { || aRelat[nI,01] } )
oPedido:Cell("ITEM")		:SetBlock( { || aRelat[nI,02] } )
oPedido:Cell("QTDE")		:SetBlock( { || aRelat[nI,03] } )
oPedido:Cell("UM")			:SetBlock( { || aRelat[nI,04] } )
oPedido:Cell("DESCRIC")		:SetBlock( { || aRelat[nI,05] } )
oPedido:Cell("UNIT")		:SetBlock( { || aRelat[nI,06] } )
oPedido:Cell("TOTAL")		:SetBlock( { || aRelat[nI,07] } )
oPedido:Cell("IPI")			:SetBlock( { || aRelat[nI,08] } )
oPedido:Cell("ENTREGA")		:SetBlock( { || aRelat[nI,09] } )
                                     
oPedido:Cell("QTDE")	:SetPicture("@E 99,999.999")
oPedido:Cell("UNIT")	:SetPicture("@E 99,999.99")
oPedido:Cell("TOTAL")	:SetPicture("@E 99,999.99")
oPedido:Cell("IPI")		:SetPicture("@E 999.99")

oReport:SetTitle(cTitulo)
oReport:SetMeter(Len(aRelat))

oPedido:Init()
_cNum   := _cNum2 := ""
_lFirst := .T.

nI := 1
While nI <= Len(aRelat)

	If _cNum <>	aRelat[NI][10]
        If !Empty(_cNum2)
			Rodap(oReport,aRelat,ni,_cNum2)
			oReport:EndPage()			
		Endif	
		oReport:nRow := 1
		Cabec(oReport,aRelat,ni)
		_lFirst := .T.
		_nlinha := oReport:Row()
		_cNum := aRelat[NI][10]
	Endif

	_nlinha2 := oReport:Row()    
	If _nlinha2 > (_nlinha + 1000) //20 linhas
		oReport:EndPage()
		oReport:nRow := 1
		Cabec(oReport,aRelat,ni)	
		_lFirst := .T.
	Endif
	
	If oReport:Cancel()
		nI++
		Exit
	EndIf
                          
	If _lFirst
		oReport:SkipLine(1)
		_lFirst := .F.
	Endif	
	
	oReport:IncMeter()
	oPedido:PrintLine()
                               
	_cNum2 := aRelat[NI][10]
	nI++

EndDo

SC7->(dbGoto(nRegSC7))

//nao retirar "nI--" pois eh utilizado na impressao do ultimo TRFunction
nI--

If !Empty(_cNum2)
	Rodap(oReport,aRelat,ni,_cNum2)
	oReport:EndPage()
Endif

oPedido:Finish()

Return NIL


Static Function Cabec(oReport,aRelat,ni)

//oReport:Box(100,100,310,2300,oPen)
oReport:Box(100,100,310,2300)
oReport:SayBitmap(0155,0150,"lgrl01.bmp",0280,0100)
oReport:Say(120,0490,Alltrim(SM0->M0_NOMECOM),oFont4)
oReport:Box(100,1800,235,2300)
oReport:Say(120,1840,"PEDIDO DE COMPRAS",oFont4)
oReport:Say(185,1980,"Nº: "+aRelat[NI][10],oFont4)
oReport:Say(190,0480,"C.G.C.: "+SM0->M0_CGC,oFont3)
oReport:Say(250,0480,"I.E.: "+SM0->M0_INSC,oFont3)
_cEmis := Alltrim(Strzero(Day(aRelat[NI][22]),2))+" de "+Alltrim(MESEXTENSO(aRelat[NI][22]))+" de "+Alltrim(Strzero(Year(aRelat[NI][22]),4))
oReport:Say(265,1650,Alltrim(SM0->M0_CIDCOB)+", "+_cEmis,oFont5)

oReport:Box(340,100,615,2300)
oReport:Say(350,0900,"Condições Gerais",oFont2)
oReport:Say(390,0115,"1 - Nenhuma alteração de preço, quantidade, prazo de entrega ou pagamento será aceita sem prévia consulta.",oFont1)
oReport:Say(430,0115,"2 - As mercadorias fora das especificações descritas no nosso pedido serão devolvidas.",oFont1)
oReport:Say(470,0115,"3 - O número deste pedido deverá constar em sua Nota Fiscal.",oFont1)
oReport:Say(510,0115,"4 - O material será recebido e sujeito a confrência posterior.",oFont1)
oReport:Say(550,0115,"5 - Recebimento de materiais: das 08:00 as 12:00 e das 13:00 as 16:00 hs",oFont1)

oReport:Box(645,100,785,2300)
oReport:Say(655,0900,"Local para Faturamento e Cobrança",oFont2)
oReport:Say(695,0115,Alltrim(SM0->M0_ENDCOB)+" - "+Alltrim(SM0->M0_BAIRCOB),oFont1)
oReport:Say(735,0115,Alltrim(SM0->M0_CIDCOB)+" - "+alltrim(SM0->M0_CEPCOB),oFont1)
oReport:Say(735,0900,"TEL: "+Alltrim(SM0->M0_TEL),oFont1)
oReport:Say(735,1600,"FAX: "+Alltrim(SM0->M0_FAX),oFont1)

oReport:Box(815,100,1050,2300)
oReport:Say(825,0115,"Fornecedor: ",oFont1)
oReport:Say(825,0290,Alltrim(aRelat[NI][12]),oFont2)

oReport:Say(825,1600,"Telefone: ",oFont1)
oReport:Say(825,1750,Alltrim(aRelat[NI][14]),oFont2)

oReport:Say(865,0115,"Contato: ",oFont1)
oReport:Say(865,0290,Alltrim(aRelat[NI][13]),oFont2)

oReport:Say(865,1600,"Fax: ",oFont1)
oReport:Say(865,1750,Alltrim(aRelat[NI][15]),oFont2)

oReport:Say(905,0115,"Endereço: ",oFont1)
oReport:Say(905,0290,Alltrim(aRelat[NI][16]),oFont2)

oReport:Say(945,0115,"Municipio: ",oFont1)
oReport:Say(945,0290,Alltrim(aRelat[NI][17]),oFont2)

oReport:Say(945,0900,"UF: ",oFont1)
oReport:Say(945,00970,Alltrim(aRelat[NI][18]),oFont2)

oReport:Say(945,1600,"CEP: ",oFont1)
oReport:Say(945,1750,Alltrim(aRelat[NI][19]),oFont2)

oReport:Say(985,0115,"CNPJ: ",oFont1)
oReport:Say(985,0290,Alltrim(aRelat[NI][20]),oFont2)

oReport:Say(985,1600,"I.E. ",oFont1)
oReport:Say(985,1750,Alltrim(aRelat[NI][21]),oFont2)

oReport:Box(1090,100,2880,2300)
oReport:SkipLine(21)

oReport:Box(2900,100,3200,2300)
oReport:Line(2900,1200,3200,1200)
oReport:Say(3000,0200,"____/____/______",oFont1)
oReport:Say(3000,0780,"___________________",oFont1)
oReport:Say(3000,1400,"____/____/______",oFont1)
oReport:Say(3000,1900,"___________________",oFont1)
oReport:Say(3050,0285,"Data",oFont1)
oReport:Say(3050,0870,"Comprador",oFont1)
oReport:Say(3050,1480,"Data",oFont1)
oReport:Say(3050,1990,"Aprovação",oFont1)

Return


Static Function Rodap(oReport,aRelat,ni,_cNum2)

oReport:nLineHeight  := 25
oReport:SkipLine(1)

_nlinha := oReport:Row()

//oReport:ThinLine()
oReport:LINE(_nlinha,100,_nlinha,2300)

oReport:SkipLine(1)
oReport:PrintText("Observação")
For F:= 1 to Len(aRelat)
	If aRelat[F][10] = _cNum2
		If !Empty(aRelat[F][11])
			oReport:SkipLine(1)
			_nlinha2 := oReport:Row()    
			If _nlinha2 > (_nlinha + 1000) //20 linhas
				oReport:EndPage()
				oReport:nRow := 1
				Cabec(oReport,aRelat,ni)	
				oReport:PrintText("Observação")
				oReport:SkipLine(1)
			Endif
			oReport:PrintText(Alltrim(aRelat[F][11]))
		Endif
	Endif	
Next f

oReport:nLineHeight  := 50

Return


Static Function PV001C(oReport)

Local oPedido		:= oReport:Section(1)
Local lContinua		:= .T.
Local tamanho		:= "G"
Local aStru		    := SC7->(DbStruct()), nI

li := 1

// Obtem os registros a serem processados

cQuery := " SELECT * FROM "+RetSqlName("SC7")+" C7 "
cQuery += " INNER JOIN "+RetSqlName("SA2")+" A2 ON C7_FORNECE+C7_LOJA = A2_COD+A2_LOJA "
cQuery += " WHERE C7.D_E_L_E_T_ = '' AND A2.D_E_L_E_T_ = ''"
cQuery += " AND C7_NUM BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"
cQuery += " ORDER BY C7_NUM,C7_ITEM "

TCQUERY cQuery NEW ALIAS "NEWSC7"

For nI := 1 TO LEN(aStru)
	If aStru[nI][2] != "C"
		TCSetField("NEWSC7", aStru[nI][1], aStru[nI][2], aStru[nI][3], aStru[nI][4])
	EndIf
Next

//cNomeArq := CriaTrab(Nil,.F.)
//IndRegua("NEWSC7",cNomeArq,"C7_NUM+C7_ITEM",,,"Selecionando Registros...")
NEWSC7->(dbGoTop())

While NEWSC7->(!Eof())
	
	AADD(aRet,{ NEWSC7->C7_ITEM,;
	NEWSC7->C7_PRODUTO,;
	NEWSC7->C7_QUANT,;
	NEWSC7->C7_UM,;
	NEWSC7->C7_DESCRI,;
	NEWSC7->C7_PRECO,;
	NEWSC7->C7_TOTAL,;
	NEWSC7->C7_IPI,;
	NEWSC7->C7_DATPRF ,;
	NEWSC7->C7_NUM ,;
	NEWSC7->C7_OBS ,;
	NEWSC7->A2_NOME,;
	NEWSC7->C7_CONTATO,;
	NEWSC7->A2_TEL ,;
	NEWSC7->A2_FAX ,;
	NEWSC7->A2_END,;
	NEWSC7->A2_MUN,;
	NEWSC7->A2_EST,;
	NEWSC7->A2_CEP,;
	NEWSC7->A2_CGC,;
	NEWSC7->A2_INSCR,;
	NEWSC7->C7_EMISSAO })
	
	NEWSC7->(dbskip())
EndDo

NEWSC7->(dbCloseArea())

/*
If cNomeArq # Nil
Ferase(cNomeArq+OrdBagExt())
Endif
*/
Return aRet


Static Function AtuSX1()

cPerg := "MX0001"
aRegs := {}

//    	   Grupo/Ordem/Pergunta               /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid          /Var01     /Def01             /defspa1/defeng1/Cnt01/Var02/Def02            /Defspa2/defeng2/Cnt02/Var03/Def03/defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
U_CRIASX1(cPerg,"01","Pedido de Compra de   ?",""       ,""      ,"mv_ch1","C" ,06     ,0      ,0     ,"G",""            ,"MV_PAR01",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"02","Pedido de Comptra ate ?",""       ,""      ,"mv_ch2","C" ,06     ,0      ,0     ,"G",""            ,"MV_PAR02",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""		,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")

Return
