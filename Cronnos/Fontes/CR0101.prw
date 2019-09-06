#INCLUDE "MATR780.CH"
#INCLUDE "TOTVS.CH"


/*/{Protheus.doc} CR0101
//Relacao de Vendas por Cliente, quantidade de cada Produto, onde foi incluído o campo IPI.
Fonte criado com base no fonte padrão MATR780
@author Fabiano
@since 24/04/2017
@version undefined
@type function
/*/
User Function CR0101()

	Local oReport

	oReport := ReportDef()
	oReport:PrintDialog()

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³ Marco Bianchi         ³ Data ³ 19/07/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpO1: Objeto do relatório                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()

	Local oReport
	Local cAliasSD1 := GetNextAlias()
	Local cAliasSD2 := GetNextAlias()
	Local cAliasSA1 := GetNextAlias()

	Local cCodProd	:= ""
	Local cDescProd	:= ""
	Local cDoc		:= ""
	Local cSerie	:= ""
	Local dEmissao	:= CTOD("  /  /  ")
	Local cUM		:= ""
	Local nTotQuant	:= 0
	Local nVlrUnit	:= 0
	Local nValadi	:= 0
	Local nVlrTot	:= 0
	Local _nVlrIPI	:= 0
	Local _nIcmRet	:= 0
	Local _nIcms	:= 0
	Local _nCusto	:= 0
	Local cVends	:= ""
	Local cClieAnt	:= ""
	Local cLojaAnt	:= ""
	Local nTamData  := Len(DTOC(MsDate()))
	Local lValadi		:= cPaisLoc == "MEX" .AND. SD2->(FieldPos("D2_VALADI")) > 0 //  Adiantamentos Mexico

	Private cSD1, cSD2

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
	oReport := TReport():New("CR0101",STR0018,"MR780A", {|oReport| ReportPrint(oReport,cAliasSD1,cAliasSD2,cAliasSA1)},STR0019 + " " + STR0020)	// "Estatisticas de Vendas (Cliente x Produto)"###"Este programa ira emitir a relacao das compras efetuadas pelo Cliente,"###"totalizando por produto e escolhendo a moeda forte para os Valores."
	oReport:SetPortrait()
	oReport:SetTotalInLine(.F.)

	Pergunte(oReport:uParam,.F.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Criacao da secao utilizada pelo relatorio                               ³
	//³                                                                        ³
	//³TRSection():New                                                         ³
	//³ExpO1 : Objeto TReport que a secao pertence                             ³
	//³ExpC2 : Descricao da seçao                                              ³
	//³ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   ³
	//³        sera considerada como principal para a seção.                   ³
	//³ExpA4 : Array com as Ordens do relatório                                ³
	//³ExpL5 : Carrega campos do SX3 como celulas                              ³
	//³        Default : False                                                 ³
	//³ExpL6 : Carrega ordens do Sindex                                        ³
	//³        Default : False                                                 ³
	//³                                                                        ³
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Criacao da celulas da secao do relatorio                                ³
	//³                                                                        ³
	//³TRCell():New                                                            ³
	//³ExpO1 : Objeto TSection que a secao pertence                            ³
	//³ExpC2 : Nome da celula do relatório. O SX3 será consultado              ³
	//³ExpC3 : Nome da tabela de referencia da celula                          ³
	//³ExpC4 : Titulo da celula                                                ³
	//³        Default : X3Titulo()                                            ³
	//³ExpC5 : Picture                                                         ³
	//³        Default : X3_PICTURE                                            ³
	//³ExpC6 : Tamanho                                                         ³
	//³        Default : X3_TAMANHO                                            ³
	//³ExpL7 : Informe se o tamanho esta em pixel                              ³
	//³        Default : False                                                 ³
	//³ExpB8 : Bloco de código para impressao.                                 ³
	//³        Default : ExpC2                                                 ³
	//³                                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Secao 1 - Cliente                                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oCliente := TRSection():New(oReport,STR0027,{"SA1","SD2TRB"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)	// "Estatisticas de Vendas (Cliente x Produto)"
	oCliente:SetTotalInLine(.F.)

	TRCell():New(oCliente,"CCLIEANT"	,/*Tabela*/	,RetTitle("D2_CLIENTE"	),PesqPict("SD2","D2_CLIENTE"	),08							,/*lPixel*/,{|| cClieAnt		})
	TRCell():New(oCliente,"CLOJA"		,/*Tabela*/	,RetTitle("D2_LOJA"		),PesqPict("SD2","D2_LOJA"		),TamSx3("D2_LOJA"			)[1],/*lPixel*/,{|| cLojaAnt				})
	TRCell():New(oCliente,"A1_NOME"		,/*Tabela*/	,RetTitle("A1_NOME"		),PesqPict("SA1","A1_NOME"		),TamSx3("A1_NOME"			)[1],/*lPixel*/,{|| (cAliasSA1)->A1_NOME	})
	TRCell():New(oCliente,"A1_OBSERV"	,/*Tabela*/	,RetTitle("A1_OBSERV"	) ,PesqPict("SA1","A1_OBSERV"	),TamSx3("A1_OBSERV"		)[1],/*lPixel*/,{|| (cAliasSA1)->A1_OBSERV	})

	// Imprimie Cabecalho no Topo da Pagina
	oReport:Section(1):SetHeaderPage()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Sub-Secao do Cliente - Produto                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oProduto := TRSection():New(oCliente,STR0028,{},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)	// "Estatisticas de Vendas (Cliente x Produto)"
	oProduto:SetTotalInLine(.F.)

	TRCell():New(oProduto,"CCODPROD"	,/*Tabela*/,RetTitle("D2_COD"		),PesqPict("SD2","D2_COD"					),TamSx3("D2_COD"		)[1],/*lPixel*/,{|| cCodProd	})
	TRCell():New(oProduto,"CDESCPROD"	,/*Tabela*/,RetTitle("B1_DESC"		),PesqPict("SB1","B1_DESC"					),TamSx3("B1_DESC"		)[1],/*lPixel*/,{|| cDescProd	})
	TRCell():New(oProduto,"CDOC"		,/*Tabela*/,RetTitle("D2_DOC"		),PesqPict("SD2","D2_DOC"					),TamSx3("D2_DOC"		)[1],/*lPixel*/,{|| cDoc		})
	TRCell():New(oProduto,"CSERIE" 		,/*Tabela*/,SerieNfId("SD2",7,"D2_SERIE"),PesqPict("SD2","D2_SERIE"				),SerieNfId("SD2",6,"D2_SERIE"),/*lPixel*/,{|| cSerie		})
	TRCell():New(oProduto,"DEMISSAO"	,/*Tabela*/,RetTitle("D2_EMISSAO"	),PesqPict("SD2","D2_EMISSAO"				),nTamData					,/*lPixel*/,{|| dEmissao	})
	TRCell():New(oProduto,"CUM"			,/*Tabela*/,RetTitle("B1_UM"		),PesqPict("SB1","B1_UM"					),TamSx3("B1_UM"		)[1],/*lPixel*/,{|| cUM			})
	TRCell():New(oProduto,"NTOTQUANT"	,/*Tabela*/,RetTitle("D2_QUANT"		),PesqPict("SD2","D2_QUANT"					),TamSx3("D2_QUANT"		)[1],/*lPixel*/,{|| nTotQuant	})
	TRCell():New(oProduto,"NVLRUNIT"	,/*Tabela*/,RetTitle("D2_PRCVEN"	),PesqPict("SD2","D2_PRCVEN"				),TamSx3("D2_PRCVEN"	)[1],/*lPixel*/,{|| nVlrUnit	})
	If lValadi
		TRCell():New(oProduto,"NVALADI"	,/*Tabela*/,RetTitle("D2_VALADI"	),PesqPict("SD2","D2_VALADI"				),TamSx3("D2_VALADI"	)[1],/*lPixel*/,{|| nValadi	})
	EndIf
	TRCell():New(oProduto,"NVLRTOT"		,/*Tabela*/,RetTitle("D2_TOTAL"		),PesqPict("SD2","D2_TOTAL"					),TamSx3("D2_TOTAL"		)[1],/*lPixel*/,{|| nVlrTot		})
	TRCell():New(oProduto,"_NVLRIPI"	,/*Tabela*/,RetTitle("D2_VALIPI"	),PesqPict("SD2","D2_VALIPI"				),TamSx3("D2_VALIPI"	)[1],/*lPixel*/,{|| _nVlrIPI	})
	TRCell():New(oProduto,"_NICMS"		,/*Tabela*/,RetTitle("D2_VALICM"	),PesqPict("SD2","D2_VALICM"				),TamSx3("D2_VALICM"	)[1],/*lPixel*/,{|| _nIcms		})
	TRCell():New(oProduto,"_NICMRET"	,/*Tabela*/,RetTitle("D2_ICMSRET"	),PesqPict("SD2","D2_ICMSRET"				),TamSx3("D2_ICMSRET"	)[1],/*lPixel*/,{|| _nIcmRet	})
	TRCell():New(oProduto,"_NCUSTO"		,/*Tabela*/,RetTitle("D2_CUSTO1"	),PesqPict("SD2","D2_CUSTO1"				),TamSx3("D2_CUSTO1"		)[1],/*lPixel*/,{|| _nCusto		})
	TRCell():New(oProduto,"CVENDS"		,/*Tabela*/,STR0024					 ,PesqPict("SF2","F2_VEND1"					),TamSx3("F2_VEND1"		)[1],/*lPixel*/,{|| cVends		})	// "Vendedor"

	// Alinhamento a direita das colunas de valor
	oProduto:Cell("NTOTQUANT"):SetHeaderAlign("RIGHT")
	oProduto:Cell("NVLRUNIT"):SetHeaderAlign("RIGHT")
	If lValadi
		oProduto:Cell("NVALADI"):SetHeaderAlign("RIGHT")
	EndIf
	oProduto:Cell("NVLRTOT"):SetHeaderAlign("RIGHT")
	oProduto:Cell("_NVLRIPI"):SetHeaderAlign("RIGHT")
	oProduto:Cell("_NICMS"):SetHeaderAlign("RIGHT")
	oProduto:Cell("_NICMRET"):SetHeaderAlign("RIGHT")
	oProduto:Cell("_NCUSTO"):SetHeaderAlign("RIGHT")

	// Totalizador por Produto
	oTotal1 := TRFunction():New(oProduto:Cell("NTOTQUANT"	),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	If lValadi
		TRFunction():New(oProduto:Cell("NVALADI"	),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	EndIf
	oTotal2 := TRFunction():New(oProduto:Cell("NVLRTOT"	),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	oTotalA := TRFunction():New(oProduto:Cell("_NVLRIPI"),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	oTotalE := TRFunction():New(oProduto:Cell("_NICMS"),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	oTotalC := TRFunction():New(oProduto:Cell("_NICMRET"),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)

	// Totalizador por Cliente
	oTotal3 := TRFunction():New(oProduto:Cell("NTOTQUANT"	),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/,oCliente)
	oTotal4 := TRFunction():New(oProduto:Cell("NVLRTOT"		),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/,oCliente)
	oTotalB := TRFunction():New(oProduto:Cell("_NVLRIPI"	),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/,oCliente)
	oTotalF := TRFunction():New(oProduto:Cell("_NICMS"		),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/,oCliente)
	oTotalD := TRFunction():New(oProduto:Cell("_NICMRET"	),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/,oCliente)
	If lValadi
		TRFunction():New(oProduto:Cell("NVALADI"	),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/,oCliente)
	EndIf

	// Imprimie Cabecalho no Topo da Pagina
	oReport:Section(1):Section(1):SetHeaderPage()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Secao 2 - Filtro das nota de devolucao                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oTemp1 := TRSection():New(oReport,STR0029,{"SD1"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)	// "Estatisticas de Vendas (Cliente x Produto)"
	oTemp1:SetTotalInLine(.F.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Secao 4 - Filtro das Notas de Saida                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oTemp3 := TRSection():New(oReport,STR0028,{"SD2"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)	// "Estatisticas de Vendas (Cliente x Produto)"
	oTemp3:SetTotalInLine(.F.)

	oReport:Section(2):SetEditCell(.F.)
	oReport:Section(3):SetEditCell(.F.)

Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrin³ Autor ³ Marco Bianchi         ³ Data ³ 19/07/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatório                           ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport,cAliasSD1,cAliasSD2,cAliasSA1)

	Local  nV := 0
	Local cProdAnt	  := "", cLojaAnt := ""
	Local lNewProd	  := .T.
	Local nTamRef	  := Val(Substr(GetMv("MV_MASCGRD"),1,2))
	Local cProdRef	  := ""
	Local cUM		  := ""
	Local nTotQuant	  := 0
	Local nReg		  := 0
	Local cFiltro	  := ""
	Local cEstoq	  := If( (mv_par13 == 1),"S",If( (mv_par13 == 2),"N","SN" ))
	Local cDupli	  := If( (mv_par14 == 1),"S",If( (mv_par14 == 2),"N","SN" ))
	Local cArqTrab1, cArqTrab2, cCondicao1
	Local aDevImpr	  := {}
	Local cVends	  := ""
	Local nVend		  := FA440CntVend()
	Local nDevQtd	  := 0
	Local nDevVal	  := 0
	Local _nDevIPI	  := 0
	Local _nDevICM	  := 0
	Local _nDevICR	  := 0
	Local aDev		  := {}
	Local nIndD2	  := 0
	Local aStru
	Local lNfD2Ori	  := .F.
	Local cVendedores := ""
	Local lNewCli     := .T.
	Local lValadi		:= cPaisLoc == "MEX" .AND. SD2->(FieldPos("D2_VALADI")) > 0 //  Adiantamentos Mexico
	#IFDEF TOP
	Local nj	:= 0
	Local cWhere:= ""
	#ELSE
	Local cCondicao := ""
	#ENDIF

	Private nIndD1  :=0
	Private nDecs	:=msdecimais(mv_par09)


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define o bloco de codigo que retornara o conteudo de impres- ³
	//³ sao da celula.                                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:Section(1):Cell("CCLIEANT" 	):SetBlock({|| cClieAnt		})
	oReport:Section(1):Cell("CLOJA" 	):SetBlock({|| cLojaAnt		})
	oReport:Section(1):Section(1):Cell("CCODPROD" 	):SetBlock({|| cCodProd		})
	oReport:Section(1):Section(1):Cell("CDESCPROD" ):SetBlock({|| cDescProd	})
	oReport:Section(1):Section(1):Cell("CDOC"		):SetBlock({|| cDoc			})
	oReport:Section(1):Section(1):Cell("CSERIE" 	):SetBlock({|| cSerie 		})
	oReport:Section(1):Section(1):Cell("DEMISSAO" 	):SetBlock({|| dEmissao		})
	oReport:Section(1):Section(1):Cell("CUM"		):SetBlock({|| cUM			})
	oReport:Section(1):Section(1):Cell("NTOTQUANT"	):SetBlock({|| nTotQuant	})
	oReport:Section(1):Section(1):Cell("NVLRUNIT" 	):SetBlock({|| nVlrUnit		})
	If lValadi
		oReport:Section(1):Section(1):Cell("NVALADI" 	):SetBlock({|| nValadi		})
	EndIf
	oReport:Section(1):Section(1):Cell("NVLRTOT" 	):SetBlock({|| nVlrTot		})
	oReport:Section(1):Section(1):Cell("_NVLRIPI" 	):SetBlock({|| _nVlrIPI		})
	oReport:Section(1):Section(1):Cell("_NICMS" 	):SetBlock({|| _nIcms		})
	oReport:Section(1):Section(1):Cell("_NICMRET" 	):SetBlock({|| _nIcmRet		})
	oReport:Section(1):Section(1):Cell("_NCUSTO" 	):SetBlock({|| _nCusto		})
	oReport:Section(1):Section(1):Cell("CVENDS" 	):SetBlock({|| cVends		})

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Seleciona ordem dos arquivos consultados no processamento    		   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SF1->(dbsetorder(1))
	SF2->(dbsetorder(1))
	SB1->(dbSetOrder(1))
	SA7->(dbSetOrder(2))

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta o Cabecalho de acordo com parametros                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:SetTitle(oReport:Title() + " " + STR0021 +GetMV("MV_SIMB"+Str(mv_par09,1)))		// "Estatisticas de Vendas (Cliente x Produto)"###"Valores em "

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Transforma parametros Range em expressao SQL                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MakeSqlExpr(oReport:uParam)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Filtra nota de devolucao                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SD1")
	cArqTrab1  := CriaTrab( "" , .F. )
	#IFDEF TOP
	If (TcSrvType()#'AS/400')
		cSD1   := "SD1TMP"
		aStru  := dbStruct()
		cWhere := "%NOT ("+IsRemito(3,'SD1.D1_TIPODOC')+ ")%"
		oReport:Section(2):BeginQuery()
		BeginSql Alias cAliasSD1
		SELECT *
		FROM %Table:SD1% SD1
		WHERE SD1.D1_FILIAL = %xFilial:SD1% AND
		SD1.D1_FORNECE >= %Exp:mv_par01% AND SD1.D1_FORNECE <= %Exp:mv_par02% AND
		SD1.D1_DTDIGIT >= %Exp:DtoS(mv_par03)% AND SD1.D1_DTDIGIT <= %Exp:DtoS(mv_par04)% AND
		SD1.D1_COD >= %Exp:mv_par05% AND SD1.D1_COD <= %Exp:mv_par06% AND
		SD1.D1_TIPO = 'D' AND
		SD1.D1_TP <> 'EM' AND
		%Exp:cWhere% AND
		SD1.%NotDel%
		ORDER BY SD1.D1_FILIAL,SD1.D1_FORNECE,SD1.D1_LOJA,SD1.D1_COD
		EndSql
		oReport:Section(2):EndQuery(/*Array com os parametros do tipo Range*/)

		A780CriaTmp(cArqTrab1, aStru, cSD1, cALiasSD1 )
		IndRegua(cSD1,cArqTrab1,"D1_FILIAL+D1_FORNECE+D1_LOJA+D1_COD",,".T.",STR0026)		// "Selecionando Registros..."
	Else
		#ENDIF
		cSD1	   := "SD1"
		dbSelectArea("SD1")
		cCondicao1 := 'D1_FILIAL=="' + xFilial("SD1") + '".And.'
		cCondicao1 += 'D1_FORNECE>="' + mv_par01 + '".And.'
		cCondicao1 += 'D1_FORNECE<="' + mv_par02 + '".And.'
		cCondicao1 += 'DtoS(D1_DTDIGIT)>="' + DtoS(mv_par03) + '".And.'
		cCondicao1 += 'DtoS(D1_DTDIGIT)<="' + DtoS(mv_par04) + '".And.'
		cCondicao1 += 'D1_COD>="' + mv_par05 + '".And.'
		cCondicao1 += 'D1_COD<="' + mv_par06 + '".And.'
		cCondicao1 += 'D1_TIPO=="D" .And. !('+IsRemito(2,'SD1->D1_TIPODOC')+')'
		cCondicao1 += '.And. D1_TP <> "EM"'

		cArqTrab1  := CriaTrab("",.F.)
		IndRegua(cSD1,cArqTrab1,"D1_FILIAL+D1_FORNECE+D1_LOJA+D1_COD",,cCondicao1,STR0026)		// "Selecionando Registros..."
		nIndD1 := RetIndex()

		#IFNDEF TOP
		dbSetIndex(cArqTrab1+ordBagExt())
		#ENDIF

		dbSetOrder(nIndD1+1)
		#IFDEF TOP
	Endif
	#ENDIF


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta filtro para processar as vendas por cliente            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("SD2")
	cFiltro := SD2->(dbFilter())
	If Empty(cFiltro)
		bFiltro := { || .T. }
	Else
		cFiltro := "{ || " + cFiltro + " }"
		bFiltro := &(cFiltro)
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta filtro para processar as vendas por cliente            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("SD2")
	cArqTrab2  := CriaTrab( "" , .F. )
	#IFDEF TOP
	If (TcSrvType()#'AS/400')
		cSD2   := "SD2TMP"
		aStru  := dbStruct()
		cWhere := "%NOT ("+IsRemito(3,'SD2.D2_TIPODOC')+ ")%"
		oReport:Section(3):BeginQuery()
		BeginSql Alias cAliasSD2
		SELECT *
		FROM %Table:SD2% SD2
		WHERE SD2.D2_FILIAL = %xFilial:SD2% AND
		SD2.D2_CLIENTE BETWEEN %Exp:mv_par01% AND %Exp:mv_par02% AND
		SD2.D2_EMISSAO BETWEEN %Exp:DTOS(mv_par03)% AND %Exp:DTOS(mv_par04)% AND
		SD2.D2_COD     BETWEEN %Exp:mv_par05% AND %Exp:mv_par06% AND
		SD2.D2_TIPO <> 'B' AND SD2.D2_TIPO <> 'D' AND
		SD2.D2_TP <> 'EM' AND
		%Exp:cWhere% AND
		SD2.%NotDel%
		ORDER BY SD2.D2_FILIAL,SD2.D2_CLIENTE,SD2.D2_LOJA,SD2.D2_COD,SD2.D2_ITEM
		EndSql
		oReport:Section(3):EndQuery()

		A780CriaTmp(cArqTrab2, aStru, cSD2, cAliasSD2)
		IndRegua(cSD2,cArqTrab2,"D2_FILIAL+D2_CLIENTE+D2_LOJA+D2_COD+D2_SERIE+D2_DOC+D2_ITEM",,".T.",STR0026)		// "Selecionando Registros..."

	Else
		#ENDIF
		cSD2	   := "SD2"
		cCondicao := 'D2_FILIAL == "' + xFilial("SD2") + '" .And. '
		cCondicao += 'D2_CLIENTE >= "' + mv_par01 + '" .And. '
		cCondicao += 'D2_CLIENTE <= "' + mv_par02 + '" .And. '
		cCondicao += 'DTOS(D2_EMISSAO) >= "' + DTOS(mv_par03) + '" .And. '
		cCondicao += 'DTOS(D2_EMISSAO) <= "' + DTOS(mv_par04) + '" .And. '
		cCondicao += 'D2_COD >= "' + mv_par05 + '" .And. '
		cCondicao += 'D2_TP <> "EM" .And. '
		cCondicao += '!(D2_TIPO $ "BD")'
		cCondicao += '.And. !('+IsRemito(2,'SD2->D2_TIPODOC')+')'

		IndRegua("SD2",cArqTrab2,"D2_FILIAL+D2_CLIENTE+D2_LOJA+D2_COD+D2_SERIE+D2_DOC+D2_ITEM",,cCondicao,STR0026)		// "Selecionando Registros..."
		nIndD2 := RetIndex()

		#IFNDEF TOP
		dbSetIndex(cArqTrab2+ordBagExt())
		#ENDIF

		dbSetOrder(nIndD2+1)
		#IFDEF TOP
	Endif
	#ENDIF


	dbSelectArea("SA1")
	dbSetOrder(1)
	#IFDEF TOP
	oReport:Section(1):BeginQuery()
	BeginSql Alias cALiasSA1
	SELECT A1_FILIAL,A1_COD,A1_LOJA,A1_NOME,A1_OBSERV
	FROM %Table:SA1% SA1
	WHERE SA1.A1_FILIAL = %xFilial:SA1% AND
	SA1.A1_COD >= %Exp:MV_PAR01% AND
	SA1.A1_COD <= %Exp:MV_PAR02% AND
	SA1.%NotDel%
	ORDER BY A1_FILIAL,A1_COD
	EndSql
	oReport:Section(1):EndQuery()
	#ENDIF

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se aglutinara produtos de Grade                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:SetMeter(RecCount())		// Total de Elementos da regua

	If ( (cSD2)->D2_GRADE=="S" .And. MV_PAR12 == 1)
		lGrade := .T.
		bGrade := { || Substr((cSD2)->D2_COD, 1, nTamref) }
	Else
		lGrade := .F.
		bGrade := { || (cSD2)->D2_COD }
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Procura pelo 1o. cliente valido                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	#IFNDEF TOP
	dbSeek(xFilial()+mv_par01, .t.)
	#ENDIF
	While !oReport:Cancel() .And. (cAliasSA1)->( ! EOF() .AND. A1_COD <= MV_PAR02 ) .And. (cAliasSA1)->A1_FILIAL == xFilial("SA1")

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Procura pelas saidas daquele cliente                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea(cSD2)
		If DbSeek(xFilial("SD2")+(cAliasSA1)->A1_COD+(cAliasSA1)->A1_LOJA)
			lRet:=ValidMasc((cSD2)->D2_COD,MV_PAR11)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Montagem da quebra do relatorio por  Cliente             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cClieAnt := (cAliasSA1)->A1_COD
			cLojaAnt := (cAliasSA1)->A1_LOJA
			lNewProd := .T.
			lNewCli  := .T.
			While !oReport:Cancel() .And.!Eof() .and. ;
			((cSD2)->(D2_FILIAL+D2_CLIENTE+D2_LOJA)) == (xFilial("SD2")+cClieAnt+cLojaAnt)

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica Se eh uma tipo de nota valida                   ³
				//³ Verifica intervalo de Codigos de Vendedor                ³
				//³ Valida o produto conforme a mascara                      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				lRet:=ValidMasc((cSD2)->D2_COD,MV_PAR11)
				If	! Eval(bFiltro) .Or. !A780Vend(@cVends,nVend) .Or. !lRet //.or. SD2->D2_TIPO$"BD" ja esta no filtro
					dbSkip()
					Loop
				EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Impressao da quebra por produto e NF                     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cProdAnt := Eval(bGrade)
				lNewProd := .T.
				oReport:Section(1):Section(1):Init()
				While !oReport:Cancel() .And. ! Eof() .And. ;
				(cSD2)->(D2_FILIAL + D2_CLIENTE + D2_LOJA  + EVAL(bGrade) ) == ;
				( xFilial("SD2") + cClieAnt   + cLojaAnt + cProdAnt )
					oReport:IncMeter()

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Avalia TES                                               ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					lRet:=ValidMasc((cSD2)->D2_COD,MV_PAR11)
					If !AvalTes((cSD2)->D2_TES,cEstoq,cDupli) .Or. !Eval(bFiltro) .Or. !lRet
						dbSkip()
						Loop
					Endif

					If !A780Vend(@cVends,nVend)
						dbskip()
						Loop
					Endif

					If lNewCli
						oReport:Section(1):Init()
						oReport:Section(1):PrintLine()
						lNewCli := .F.
					EndIf
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Se mesmo produto inibe impressao do codigo e descricao   ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If lNewProd
						lNewProd := .F.
						oReport:Section(1):Section(1):Cell("CCODPROD"	):Show()
						oReport:Section(1):Section(1):Cell("CDESCPROD"	):Show()
						//Se for tipo planilha e estilo relatório em formato de tabela.
					ElseIf	oReport:nDevice == 4 .AND. oReport:nXlsStyle == 1
						oReport:Section(1):Section(1):Cell("CCODPROD"	):Show()
						oReport:Section(1):Section(1):Cell("CDESCPROD"	):Show()
					Else
						oReport:Section(1):Section(1):Cell("CCODPROD"	):Hide()
						oReport:Section(1):Section(1):Cell("CDESCPROD"	):Hide()
					EndIf

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Caso seja grade aglutina todos produtos do mesmo Pedido  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If lGrade  // Aglutina Grade
						cProdRef:= Substr((cSD2)->D2_COD,1,nTamRef)
						cNumPed := (cSD2)->D2_PEDIDO
						nReg    := 0
						nDevQtd := 0
						nDevVal := 0
						_nDevIPI := 0
						_nDevICR := 0
						_nDevICM := 0

						While !oReport:Cancel() .And. !Eof() .And. cProdRef == Eval(bGrade) .And.;
						(cSD2)->D2_GRADE == "S" .And. cNumPed == (cSD2)->D2_PEDIDO .And.;
						(cSD2)->D2_FILIAL == xFilial("SD2")

							nReg := Recno()
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Valida o produto conforme a mascara         ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							lRet:=ValidMasc((cSD2)->D2_COD,MV_PAR11)
							If !lRet .Or. !Eval(bFiltro)
								dbSkip()
								Loop
							EndIf

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Tratamento das Devolu‡oes   ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If mv_par10 == 1 //inclui Devolucoes
								SomaDev(@nDevQtd, @nDevVal , @aDev, cEstoq, cDupli, @_nDevIPI, @_nDevICR, @_nDevICM)
							EndIf

							nTotQuant += (cSD2)->D2_QUANT
							dbSkip()

						EndDo

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Verifica se processou algum registro        ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If nReg > 0
							dbGoto(nReg)
							nReg:=0
						EndIf

					Else
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Tratamento das devolucoes   ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						nDevQtd :=0
						nDevVal :=0
						_nDevIPI:=0
						_nDevICR:=0
						_nDevICM:=0

						If mv_par10 == 1 //inclui Devolucoes
							SomaDev(@nDevQtd, @nDevVal , @aDev, cEstoq, cDupli,@_nDevIPI,@_nDevICR, @_nDevICM)
						EndIf

						nTotQuant := (cSD2)->D2_QUANT

					EndIf

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Imprime os dados da NF                                   ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					SB1->(dbSeek(xFilial("SB1")+(cSD2)->D2_COD))
					If mv_par16 = 1
						cDescProd := SB1->B1_DESC
					Else
						If SA7->(dbSeek(xFilial("SA7")+(cSD2)->(D2_COD+D2_CLIENTE+D2_LOJA)))
							cDescProd := SA7->A7_DESCCLI
						Else
							cDescProd := SB1->B1_DESC
						Endif
					EndIf

					SF2->(dbSeek(xFilial("SF2")+(cSD2)->(D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA)))
					cUM      := (cSD2)->D2_UM
					cDoc     := (cSD2)->D2_DOC
					cSerie   := (cSD2)->&(SerieNfId("SD2",3,"D2_SERIE"))
					dEmissao := (cSD2)->D2_EMISSAO

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Faz Verificacao da Moeda Escolhida e Imprime os Valores  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					nVlrUnit := xMoeda((cSD2)->D2_PRCVEN,SF2->F2_MOEDA,MV_PAR09,(cSD2)->D2_EMISSAO,nDecs+1,SF2->F2_TXMOEDA)
					If lValadi
						nValadi := xMoeda((cSD2)->D2_VALADI,SF2->F2_MOEDA,MV_PAR09,(cSD2)->D2_EMISSAO,nDecs+1,SF2->F2_TXMOEDA)
					EndIf
					If (cSD2)->D2_TIPO $ "CIP"
						If cPaisLoc == "BRA"
							nVlrTot:= nVlrUnit
						ElseIf (cSD2)->D2_TIPO $ "C"
							nVlrTot:= nTotQuant * nVlrUnit
						EndIf
					Else
						If (cSD2)->D2_GRADE == "S" .And. MV_PAR12 == 1 // Aglutina Grade
							nVlrTot:= nVlrUnit * nTotQuant
						Else
							nVlrTot:=xmoeda((cSD2)->D2_TOTAL,SF2->F2_MOEDA,mv_par09,(cSD2)->D2_EMISSAO,nDecs+1,SF2->F2_TXMOEDA)
						EndIf
					EndIf

					cCodProd 	:= Eval(bGrade)

					_nVlrIPI := (cSD2)->D2_VALIPI
					_nIcms   := (cSD2)->D2_VALICM
					_nIcmRet := (cSD2)->D2_ICMSRET
//					_nCusto  := Posicione("SB2",1,xFilial("SB2")+cCodProd,"B2_CM1")
					_nCusto  := Posicione("SB1",1,xFilial("SB1")+cCodProd,"B1_CUSTD")

					A780Vend(@cVends,nVend)
					cVendedores := cVends
					cVends 		:= Subs(cVendedores,1,7)
					oReport:Section(1):Section(1):PrintLine()

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Impressao dos Vendedores                                 ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					oReport:section(1):section(1):Cell("CCODPROD"	):Hide()
					oReport:section(1):section(1):Cell("CDESCPROD"	):Hide()
					oReport:section(1):section(1):Cell("CDOC"		):Hide()
					oReport:section(1):section(1):Cell("CSERIE"		):Hide()
					oReport:section(1):section(1):Cell("DEMISSAO"	):Hide()
					oReport:section(1):section(1):Cell("CUM"		):Hide()
					oReport:section(1):section(1):Cell("NTOTQUANT"	):Hide()
					oReport:section(1):section(1):Cell("NVLRUNIT"	):Hide()
					If lValadi
						oReport:section(1):section(1):Cell("NVALADI"	):Hide()
					EndIf
					oReport:section(1):section(1):Cell("NVLRTOT"	):Hide()
					oReport:section(1):section(1):Cell("_NVLRIPI"	):Hide()
					oReport:section(1):section(1):Cell("_NICMS"	):Hide()
					oReport:section(1):section(1):Cell("_NICMRET"	):Hide()
					oReport:section(1):section(1):Cell("_NCUSTO"	):Hide()

					nTotQuant := 0		// Zera variaveis para que nao sejam somadas novamente nos totalizadores
					nVlrTot   := 0		// na impressao dos outros vendedores
					_nVlrIPI  := 0		// na impressao dos outros vendedores
					_nIcms    := 0		// na impressao dos outros vendedores
					_nIcmRet  := 0		// na impressao dos outros vendedores
					_nCusto   := 0		// na impressao dos outros vendedores
					For nV := 8 to Len(cVendedores)
						cVends := Space(20)+Subs(cVendedores,nV,7)
						oReport:Section(1):Section(1):PrintLine()
						nV += 6
					Next

					oReport:section(1):section(1):Cell("CCODPROD"	):Show()
					oReport:section(1):section(1):Cell("CDESCPROD"	):Show()
					oReport:section(1):section(1):Cell("CDOC"		):Show()
					oReport:section(1):section(1):Cell("CSERIE"	):Show()
					oReport:section(1):section(1):Cell("DEMISSAO"	):Show()
					oReport:section(1):section(1):Cell("CUM"		):Show()
					oReport:section(1):section(1):Cell("NTOTQUANT"	):Show()
					oReport:section(1):section(1):Cell("NVLRUNIT"	):Show()
					If lValadi
						oReport:section(1):section(1):Cell("NVALADI"	):Show()
					EndIf
					oReport:section(1):section(1):Cell("NVLRTOT"	):Show()
					oReport:section(1):section(1):Cell("_NVLRIPI"	):Show()
					oReport:section(1):section(1):Cell("_NICMS"		):Show()
					oReport:section(1):section(1):Cell("_NICMRET"	):Show()
					oReport:section(1):section(1):Cell("_NCUSTO"	):Show()


					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Imprime as devolucoes do produto selecionado             ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If nDevQtd!=0
						cSerie 	:= STR0025	// "DEV"
						nVlrTot   := nDevVal
						nTotQuant := nDevQtd
						_nVlrIPI  := _nDevIPI
						_nIcms    := _nDevICM
						_nIcmRet  := _nDevICR
//						_nCusto   := Posicione("SB2",1,xFilial("SB2")+cCodProd,"B2_CM1")
						_nCusto   := Posicione("SB1",1,xFilial("SB1")+cCodProd,"B1_CUSTD")

						oReport:Section(1):Section(1):Cell("CDOC"		):Hide()
						oReport:Section(1):Section(1):Cell("DEMISSAO"	):Hide()
						oReport:Section(1):Section(1):Cell("NVLRUNIT"	):Hide()
						If lValadi
							oReport:section(1):section(1):Cell("NVALADI"	):Hide()
						EndIf
						oReport:Section(1):Section(1):Cell("CVENDS"	):Hide()

						oReport:Section(1):Section(1):PrintLine()

						oReport:Section(1):Section(1):Cell("CDOC"		):Show()
						oReport:Section(1):Section(1):Cell("DEMISSAO"	):Show()
						oReport:Section(1):Section(1):Cell("NVLRUNIT"	):Show()
						If lValadi
							oReport:section(1):section(1):Cell("NVALADI"	):Show()
						EndIf
						oReport:Section(1):Section(1):Cell("CVENDS"	):Show()

					EndIf
					nTotQuant := 0
					dbSkip()

				EndDo

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Imprime o total do produto selecionado                   ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				oReport:Section(1):Section(1):SetTotalText(STR0022 + cProdAnt)	// "TOTAL DO PRODUTO - "
				oReport:Section(1):Section(1):Finish()

			EndDo
			oReport:Section(1):SetTotalText(STR0023 + cClieAnt)	// "TOTAL DO CLIENTE - "
			If !lNewCli
				oReport:section(1):Finish()
			EndIf
			cClieAnt := ""
			cLojaAnt := ""

		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Procura pelas devolucoes dos clientes que nao tem NF SAIDA  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea(cSD1)
		If DbSeek(xFilial("SD1")+(cAliasSA1)->A1_COD+(cAliasSA1)->A1_LOJA)
			lRet:=ValidMasc((cSD1)->D1_COD,MV_PAR11)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Procura as devolucoes do periodo, mas que nao pertencem  ³
			//³ as NFS ja impressas do cliente selecionado               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If mv_par10 == 1  // Inclui Devolucao

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Soma Devolucoes          ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				oReport:Section(1):Init()
				While !oReport:Cancel() .And. (cSD1)->(D1_FILIAL + D1_FORNECE + D1_LOJA) == ;
				( xFilial("SD1") + (cAliasSA1)->A1_COD+ (cAliasSA1)->A1_LOJA)  .AND. ! Eof()
					lRet:=ValidMasc((cSD1)->D1_COD,MV_PAR11)

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica Vendedores da N.F.Original ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

					CtrlVndDev := .F.
					lNfD2Ori   := .F.
					If AvalTes((cSD1)->D1_TES,cEstoq,cDupli)
						dbSelectArea("SD2")
						nSavOrd := IndexOrd()
						dbSetOrder(3)

						dbSeek(xFilial("SD2")+(cSD1)->(D1_NFORI+D1_SERIORI+D1_FORNECE+D1_LOJA+D1_COD))
						While !oReport:Cancel() .And. !Eof() .And. (xFilial("SD2")+(cSD1)->(D1_NFORI+D1_SERIORI+D1_FORNECE+D1_LOJA+D1_COD)) == ;
						D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD

							lRet:=ValidMasc((cSD1)->D1_COD,MV_PAR11)

							If !Empty((cSD1)->D1_ITEMORI) .AND. AllTrim((cSD1)->D1_ITEMORI) != D2_ITEM .Or. !lRet .Or. !Eval(bFiltro)
								dbSkip()
								Loop
							Else
								CtrlVndDev := A780Vend(@cVends,nVend)
								If Ascan(aDev,D2_CLIENTE + D2_LOJA + D2_COD + D2_DOC + D2_SERIE + D2_ITEM) > 0
									lNfD2Ori := .T.
								EndIf
							Endif
							dbSkip()
						End

						dbSelectArea("SD2")
						dbSetOrder(nSavOrd)
						dbSelectArea(cSD1)

						If !(CtrlVndDev) .Or. lNfD2Ori
							dbSkip()
							Loop
						EndIf

						SF1->(dbSeek(xFilial("SF1")+(cSD1)->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)))
						cUM := (cSD1)->D1_UM
						cDoc := (cSD1)->D1_DOC
						cSerie := (cSD1)->&(SerieNfId("SD1",3,"D1_SERIE"))
						dEmissao := (cSD1)->D1_EMISSAO
						nVlrTot:=xMoeda((cSD1)->(D1_TOTAL-D1_VALDESC),SF1->F1_MOEDA,mv_par09,(cSD1)->D1_DTDIGIT,nDecs,SF1->F1_TXMOEDA)
						_nVlrIPI := (cSD1)->D1_VALIPI
						_nIcms   := (cSD1)->D1_VALICM
						_nIcmRet := (cSD1)->D1_ICMSRET
//						_nCusto  := Posicione("SB2",1,xFilial("SB2")+(cSD1)->D1_COD,"B2_CM1")
						_nCusto  := Posicione("SB1",1,xFilial("SB1")+(cSD1)->D1_COD,"B1_CUSTD")
						If (SD2TMP->(EOF()) .And. SD1TMP->(!EOF())) .Or. (SD2TMP->(!EOF()) .And. SD1TMP->(!EOF()))
							cClieAnt := (cAliasSA1)->A1_COD
							cLojaAnt := (cAliasSA1)->A1_LOJA
							cCodProd := D1_COD
							cDescProd := Posicione("SB1",1,xFilial("SB1")+cCodProd,"B1_DESC")
							cDoc := D1_DOC
							cSerie := SerieNfId("SD1",2,"D1_SERIE")
							dEmissao := D1_EMISSAO
							cUM := D1_UM
							nTotQuant := D1_QUANT * -1
							nVlrUnit := D1_VUNIT * -1
							nVlrTot  := D1_TOTAL * -1
							_nVlrIPI := D1_VALIPI * -1
							_nIcms   := D1_VALICM * -1
							_nIcmRet := D1_ICMSRET * -1
//							_nCusto  := Posicione("SB2",1,xFilial("SB2")+cCodProd,"B2_CM1")
							_nCusto  := Posicione("SB1",1,xFilial("SB1")+cCodProd,"B1_CUSTD")

							cVends := cVends
							oReport:Section(1):PrintLine()
							oReport:Section(1):Section(1):Init()
						EndIf
						oReport:Section(1):Section(1):PrintLine()
					Endif
					dbSkip()
				EndDo
			EndIf

		Endif

		DbSelectArea(cAliasSA1)
		DbSkip()
	EndDo

	(cSD1)->(DbCloseArea())
	(cSD2)->(DbCloseArea())

Return



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ A780Vend ³ Autor ³ Rogerio F. Guimaraes  ³ Data ³ 28.10.97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica Intervalo de Vendedores                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CR0101			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function A780Vend(cVends,nVend)
	Local cAlias:=Alias(),sVend,sCampo
	Local lVend, cVend, cBusca
	Local nx
	lVend  := .F.
	cVends := ""
	// Nao tem Alias na frente dos campos do SD2 para poder trabalhar em DBF e TOP
	cBusca := xFilial("SF2")+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA
	dbSelectArea("SF2")
	If dbSeek(cBusca)
		cVend := "1"
		For nx := 1 to nVend
			sCampo := "F2_VEND" + cVend
			sVend := FieldGet(FieldPos(sCampo))
			If (sVend >= mv_par07 .And. sVend <= mv_par08) .And. (!Empty(sVend))
				cVends += If(Len(cVends)>0,"/","") + sVend
			EndIf
			If (sVend >= mv_par07 .And. sVend <= mv_par08) .And. (nX == 1 .Or. !Empty(sVend))
				lVend := .T.
			EndIf
			cVend := Soma1(cVend, 1)
		Next
	EndIf
	dbSelectArea(cAlias)
Return(lVend)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ SomaDev  ³ Autor ³ Claudecino C Leao     ³ Data ³ 28.09.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Soma devolucoes de Vendas                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CR0101			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function SomaDev(nDevQtd, nDevVal, aDev, cEstoq, cDupli, _nDevIPI,_nDevICR,_nDevICM )

	Local DtMoedaDev  := (cSD2)->D2_EMISSAO

	If (cSD1)->(dbSeek(xFilial("SD1")+(cSD2)->(D2_CLIENTE + D2_LOJA + D2_COD )))
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Soma Devolucoes          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		While (cSD1)->(D1_FILIAL+D1_FORNECE+D1_LOJA+D1_COD) == (cSD2)->( xFilial("SD2")+D2_CLIENTE+D2_LOJA+D2_COD).AND.!(cSD1)->(Eof())

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Avalia TES                                               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !AvalTes((cSD1)->D1_TES,cEstoq,cDupli)
				(cSD1)->(dbSkip())
				Loop
			Endif

			DtMoedaDev  := IIF(MV_PAR17 == 1,(cSD1)->D1_DTDIGIT,(cSD2)->D2_EMISSAO)

			SF1->(dbSeek(xFilial("SF1")+(cSD1)->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)))

			If (cSD1)->(D1_NFORI + D1_SERIORI + AllTrim(D1_ITEMORI)) == (cSD2)->(D2_DOC   + D2_SERIE   + D2_ITEM )

				Aadd(aDev, (cSD1)->(D1_FORNECE + D1_LOJA + D1_COD + D1_NFORI + D1_SERIORI + AllTrim(D1_ITEMORI)))
				nDevQtd -= (cSD1)->D1_QUANT
				nDevVal -=xMoeda((cSD1)->(D1_TOTAL-D1_VALDESC),SF1->F1_MOEDA,mv_par09,DtMoedaDev,nDecs+1,SF1->F1_TXMOEDA)
				_nDevIPI -= (cSD1)->D1_VALIPI
				_nDevICM -= (cSD1)->D1_VALICM
				_nDevICR -= (cSD1)->D1_ICMSRET

			ElseIf mv_par15 == 2 .And. (cSD1)->D1_DTDIGIT < (cSD2)->D2_EMISSAO .And.;
			(cSD1)->(D1_NFORI + D1_SERIORI + AllTrim(D1_ITEMORI)) < ;
			(cSD2)->(D2_DOC   + D2_SERIE   + D2_ITEM ) .And.;
			Ascan(aDev, (cSD1)->(D1_FORNECE + D1_LOJA + D1_COD + D1_NFORI + D1_SERIORI + AllTrim(D1_ITEMORI))) == 0

				Aadd(aDev, (cSD1)->(D1_FORNECE + D1_LOJA + D1_COD + D1_NFORI + D1_SERIORI + AllTrim(D1_ITEMORI)))
				nDevQtd -= (cSD1)->D1_QUANT
				nDevVal -=xMoeda((cSD1)->(D1_TOTAL-D1_VALDESC),SF1->F1_MOEDA,mv_par09,DtMoedaDev,nDecs+1,SF1->F1_TXMOEDA)
				_nDevIPI -= (cSD1)->D1_VALIPI
				_nDevICM -= (cSD1)->D1_VALICM
				_nDevICR -= (cSD1)->D1_ICMSRET

			EndIf

			(cSD1)->(dbSkip())

		EndDo

	EndIf
Return .t.
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³A780CriaTmp³ Autor ³ Rubens Joao Pante     ³ Data ³ 04/07/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Cria temporario a partir da consulta corrente (TOP)          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³CR0101 (TOPCONNECT)                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function A780CriaTmp(cArqTmp, aStruTmp, cAliasTmp, cAlias)

	Local nI, nF, nPos
	Local cFieldName := ""
	nF := (cAlias)->(Fcount())
	dbCreate(cArqTmp,aStruTmp)
	DbUseArea(.T.,,cArqTmp,cAliasTmp,.T.,.F.)
	(cAlias)->(DbGoTop())
	While ! (cAlias)->(Eof())
		(cAliasTmp)->(DbAppend())
		For nI := 1 To nF
			cFieldName := (cAlias)->( FieldName( ni ))
			If (nPos := (cAliasTmp)->(FieldPos(cFieldName))) > 0
				(cAliasTmp)->(FieldPut(nPos,(cAlias)->(FieldGet((cAlias)->(FieldPos(cFieldName))))))
			EndIf
		Next
		(cAlias)->(DbSkip())
	End
	(cAlias)->(dbCloseArea())
	DbSelectArea(cAliasTmp)
Return Nil
