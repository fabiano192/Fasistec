#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
Autor 		: Fabiano da Silva
Data 		: 18/07/12
Programa  	: PA0226
Descriчуo 	: Relacao de Pedidos nao entregues
*/

User Function PA0226()

Local oReport
Private cAliasQry

oReport := PA226A()
oReport:PrintDialog()

Return


Static Function PA226A()

Local oReport
Local oPedNEnt
Local oProduto
Local oCliente
Local oData
Local cTrfun

Local cPerg		:= "PA0125"
Local cWhere	:= ""
Local cQueryAdd := ""

cAliasQry := GetNextAlias()

oReport := TReport():New("PA0226","Relacao de Pedidos nao entregues",cPerg, {|oReport|PA226B(oReport,cAliasQry,oPedNEnt,oProduto,oCliente,oData)},"Este programa ira emitir a relacao dos Pedidos Pendentes, imprimindo o numero do Pedido, Cliente, Data da Entrega, Qtde pedida, Qtde ja entregue,Saldo do Produto e atraso.")

//oReport:cFontBody := 'Arial'
oReport:nFontBody := 08
oReport:SetLandscape()
oReport:SetTotalInLine(.F.)

//Г Por Pedido
oPedNEnt := TRSection():New(oReport,"Relacao de Pedidos nao entregues",{"TRB","SC6","SA1","SB1","SF4"},{"Por Pedido","Por Produto","Por Cliente","Por Dt.Entrega"},/*Campos do SX3*/,/*Campos do SIX*/)
oPedNEnt:SetTotalInLine(.F.)

TRCell():New(oPedNEnt,"NUM"		,	  ,"Pedido"					 ,                          	 ,06                   		,/*lPixel*/,{|| TRB->NUM				})
TRCell():New(oPedNEnt,"ITEM"	,	  ,"IT"					 	 ,								 ,02						,/*lPixel*/,{|| TRB->ITEM 				})
TRCell():New(oPedNEnt,"TIPO"	,"TRB","TP"						 ,PesqPict("SC6","C6_PEDAMOS"	),TamSx3("C6_PEDAMOS"	)[1],/*lPixel*/,{|| TRB->TIPO				})
TRCell():New(oPedNEnt,"CLIENTE"	,	  ,"Cliente"				 ,								 ,07						,/*lPixel*/,{|| TRB->CLIENTE			})
TRCell():New(oPedNEnt,"LOJA"	,	  ,"LJ"						 ,								 ,02						,/*lPixel*/,{|| TRB->LOJA 				})
TRCell():New(oPedNEnt,"PRODUTO"	,     ,"Produto"				 ,                             	 ,07						,.F.	   ,{|| TRB->PRODUTO			})
TRCell():New(oPedNEnt,"PRODCLI"	,     ,"Cod Cliente"          	 ,                             	 ,12                        ,.F.       ,{|| TRB->PRODCLI			})
	TRCell():New(oPedNEnt,"PEDICLI"	,     ,"Ordem Compra"          	 ,                             	 ,12                        ,.F.       ,{|| TRB->PEDICLI			})
TRCell():New(oPedNEnt,"DATENTR"	,	  ,"Entrega"				 ,                            	 ,08				    	,/*lPixel*/,{|| TRB->DATENTR			})	// Data de Entrega
TRCell():New(oPedNEnt,"MATERIAL",     ,"Material"				 ,								 ,20						,          ,{|| TRB->MATERIAL			})
TRCell():New(oPedNEnt,"INSERTO" ,     ,"Inserto"				 ,								 ,15						,          ,{|| TRB->INSERTO			})
TRCell():New(oPedNEnt,"NSALDO"	,	  ,"Saldo"			 		 ,"@E 999,999.99"				 ,10						,/*lPixel*/,{|| TRB->NSALDO	},"RIGHT",,"RIGHT")
TRCell():New(oPedNEnt,"SLDACA"	,	  ,"Acabamento"				 ,"@E 999,999.99"				 ,10						,/*lPixel*/,{|| TRB->SLDACA	},"RIGHT",,"RIGHT")
TRCell():New(oPedNEnt,"SLDCQ"	,	  ,"CQ"			 			 ,"@E 999,999.99"				 ,10						,/*lPixel*/,{|| TRB->SLDCQ	},"RIGHT",,"RIGHT")
TRCell():New(oPedNEnt,"OBS"		,	  ,"Obs"				 	 ,								 ,10						,/*lPixel*/,{|| TRB->OBS	})
	TRCell():New(oPedNEnt,"EMBAL"	,	  ,"Embalagem"				 ,								 ,10						,/*lPixel*/,{|| TRB->EMBA	})
	TRCell():New(oPedNEnt,"QTPEMB"	,	  ,"Qtde p/ Emb."		 	 ,"@E 999,999.99"				 ,10						,/*lPixel*/,{|| TRB->QTPEMB	},"RIGHT",,"RIGHT")
	TRCell():New(oPedNEnt,"QTEMBA"	,	  ,"Qtde de Emb."		 	 ,"@E 999,999.99"				 ,10						,/*lPixel*/,{|| TRB->QTEMBA	},"RIGHT",,"RIGHT")
	TRCell():New(oPedNEnt,"RECURSO"	,	  ,"Recurso"		 	 	 ,								 ,20						,/*lPixel*/,{|| TRB->RECURSO			})

//Г Por Produto
oProduto := TRSection():New(oReport,"Relacao de Pedidos nao entregues",{"TRB","SC6","SA1","SB1","SF4"},{"Por Pedido","Por Produto","Por Cliente","Por Dt.Entrega"},/*Campos do SX3*/,/*Campos do SIX*/)
oProduto:SetTotalInLine(.F.)

TRCell():New(oProduto,"PRODUTO"	,     ,"Produto"				 ,                             	 ,07						,.F.	   ,{|| TRB->PRODUTO			})
TRCell():New(oProduto,"PRODCLI"	,     ,"Cod Cliente"          	 ,                             	 ,12                        ,.F.       ,{|| TRB->PRODCLI			})
	TRCell():New(oProduto,"PEDICLI"	,     ,"Ordem Compra"          	 ,                             	 ,12                        ,.F.       ,{|| TRB->PEDICLI			})
TRCell():New(oProduto,"DATENTR"	,	  ,"Entrega"				 ,                            	 ,08				    	,/*lPixel*/,{|| TRB->DATENTR			})	// Data de Entrega
TRCell():New(oProduto,"CLIENTE"	,	  ,"Cliente"				 ,								 ,07						,/*lPixel*/,{|| TRB->CLIENTE			})
TRCell():New(oProduto,"LOJA"	,	  ,"LJ"						 ,								 ,02						,/*lPixel*/,{|| TRB->LOJA 				})
TRCell():New(oProduto,"NUM"		,	  ,"Pedido"					 ,                          	 ,06                   		,/*lPixel*/,{|| TRB->NUM				})
TRCell():New(oProduto,"ITEM"	,	  ,"IT"					 	 ,								 ,02						,/*lPixel*/,{|| TRB->ITEM 				})
TRCell():New(oProduto,"TIPO"	,"TRB","TP"						 ,PesqPict("SC6","C6_PEDAMOS"	),TamSx3("C6_PEDAMOS"	)[1],/*lPixel*/,{|| TRB->TIPO				})
TRCell():New(oProduto,"MATERIAL",     ,"Material"				 ,								 ,20						,          ,{|| TRB->MATERIAL			})
TRCell():New(oProduto,"INSERTO" ,     ,"Inserto"				 ,								 ,15						,          ,{|| TRB->INSERTO			})
TRCell():New(oProduto,"NSALDO"	,	  ,"Saldo"			 		 ,"@E 999,999.99"				 ,10						,/*lPixel*/,{|| TRB->NSALDO	},"RIGHT",,"RIGHT")
TRCell():New(oProduto,"SLDACA"	,	  ,"Acabamento"				 ,"@E 999,999.99"				 ,10						,/*lPixel*/,{|| TRB->SLDACA	},"RIGHT",,"RIGHT")
TRCell():New(oProduto,"SLDCQ"	,	  ,"CQ"			 			 ,"@E 999,999.99"				 ,10						,/*lPixel*/,{|| TRB->SLDCQ	},"RIGHT",,"RIGHT")
TRCell():New(oProduto,"OBS"		,	  ,"Obs"				 	 ,								 ,10						,/*lPixel*/,{|| TRB->OBS	})
	TRCell():New(oProduto,"EMBAL"	,	  ,"Embalagem"				 ,								 ,10						,/*lPixel*/,{|| TRB->EMBA	})
	TRCell():New(oProduto,"QTPEMB"	,	  ,"Qtde p/ Emb."		 	 ,"@E 999,999.99"				 ,10						,/*lPixel*/,{|| TRB->QTPEMB	},"RIGHT",,"RIGHT")
	TRCell():New(oProduto,"QTEMBA"	,	  ,"Qtde de Emb."		 	 ,"@E 999,999.99"				 ,10						,/*lPixel*/,{|| TRB->QTEMBA	},"RIGHT",,"RIGHT")
	TRCell():New(oProduto,"RECURSO"	,	  ,"Recurso"		 	 	 ,								 ,20						,/*lPixel*/,{|| TRB->RECURSO			})

//Г Por Cliente
oCliente := TRSection():New(oReport,"Relacao de Pedidos nao entregues",{"TRB","SC6","SA1","SB1","SF4"},{"Por Pedido","Por Produto","Por Cliente","Por Dt.Entrega"},/*Campos do SX3*/,/*Campos do SIX*/)
oCliente:SetTotalInLine(.F.)

TRCell():New(oCliente,"CLIENTE"	,	  ,"Cliente"				 ,								 ,07						,/*lPixel*/,{|| TRB->CLIENTE			})
TRCell():New(oCliente,"LOJA"	,	  ,"LJ"						 ,								 ,02						,/*lPixel*/,{|| TRB->LOJA 				})
TRCell():New(oCliente,"NUM"		,	  ,"Pedido"					 ,                          	 ,06                   		,/*lPixel*/,{|| TRB->NUM				})
TRCell():New(oCliente,"ITEM"	,	  ,"IT"					 	 ,								 ,02						,/*lPixel*/,{|| TRB->ITEM 				})
TRCell():New(oCliente,"TIPO"	,"TRB","TP"						 ,PesqPict("SC6","C6_PEDAMOS"	),TamSx3("C6_PEDAMOS"	)[1],/*lPixel*/,{|| TRB->TIPO				})
TRCell():New(oCliente,"PRODUTO"	,     ,"Produto"				 ,                             	 ,07						,.F.	   ,{|| TRB->PRODUTO			})
TRCell():New(oCliente,"PRODCLI"	,     ,"Cod Cliente"          	 ,                             	 ,12                        ,.F.       ,{|| TRB->PRODCLI			})
	TRCell():New(oCliente,"PEDICLI"	,     ,"Ordem Compra"          	 ,                             	 ,12                        ,.F.       ,{|| TRB->PEDICLI			})
TRCell():New(oCliente,"DATENTR"	,	  ,"Entrega"				 ,                            	 ,08				    	,/*lPixel*/,{|| TRB->DATENTR			})	// Data de Entrega
TRCell():New(oCliente,"MATERIAL",     ,"Material"				 ,								 ,20						,          ,{|| TRB->MATERIAL			})
TRCell():New(oCliente,"INSERTO" ,     ,"Inserto"				 ,								 ,15						,          ,{|| TRB->INSERTO			})
TRCell():New(oCliente,"NSALDO"	,	  ,"Saldo"			 		 ,"@E 999,999.99"				 ,10						,/*lPixel*/,{|| TRB->NSALDO	},"RIGHT",,"RIGHT")
TRCell():New(oCliente,"SLDACA"	,	  ,"Acabamento"				 ,"@E 999,999.99"				 ,10						,/*lPixel*/,{|| TRB->SLDACA	},"RIGHT",,"RIGHT")
TRCell():New(oCliente,"SLDCQ"	,	  ,"CQ"			 			 ,"@E 999,999.99"				 ,10						,/*lPixel*/,{|| TRB->SLDCQ	},"RIGHT",,"RIGHT")
TRCell():New(oCliente,"OBS"		,	  ,"Obs"				 	 ,								 ,10						,/*lPixel*/,{|| TRB->OBS	})
	TRCell():New(oCliente,"EMBAL"	,	  ,"Embalagem"				 ,								 ,10						,/*lPixel*/,{|| TRB->EMBA	})
	TRCell():New(oCliente,"QTPEMB"	,	  ,"Qtde p/ Emb."		 	 ,"@E 999,999.99"				 ,10						,/*lPixel*/,{|| TRB->QTPEMB	},"RIGHT",,"RIGHT")
	TRCell():New(oCliente,"QTEMBA"	,	  ,"Qtde de Emb."		 	 ,"@E 999,999.99"				 ,10						,/*lPixel*/,{|| TRB->QTEMBA	},"RIGHT",,"RIGHT")
	TRCell():New(oCliente,"RECURSO"	,	  ,"Recurso"		 	 	 ,								 ,20						,/*lPixel*/,{|| TRB->RECURSO			})

//Г Por Data de Entrega
oData := TRSection():New(oReport,"Relacao de Pedidos nao entregues",{"TRB","SC6","SA1","SB1","SF4"},{"Por Pedido","Por Produto","Por Cliente","Por Dt.Entrega"},/*Campos do SX3*/,/*Campos do SIX*/)
oData:SetTotalInLine(.F.)

TRCell():New(oData,"DATENTR"	,	  ,"Entrega"				 ,                            	 ,08				    	,/*lPixel*/,{|| TRB->DATENTR			})	// Data de Entrega
TRCell():New(oData,"CLIENTE"	,	  ,"Cliente"				 ,								 ,07						,/*lPixel*/,{|| TRB->CLIENTE			})
TRCell():New(oData,"LOJA"		,	  ,"LJ"						 ,								 ,02						,/*lPixel*/,{|| TRB->LOJA 				})
TRCell():New(oData,"NUM"		,	  ,"Pedido"					 ,                          	 ,06                   		,/*lPixel*/,{|| TRB->NUM				})
TRCell():New(oData,"ITEM"		,	  ,"IT"					 	 ,								 ,02						,/*lPixel*/,{|| TRB->ITEM 				})
TRCell():New(oData,"TIPO"		,"TRB","TP"						 ,PesqPict("SC6","C6_PEDAMOS"	),TamSx3("C6_PEDAMOS"	)[1],/*lPixel*/,{|| TRB->TIPO				})
TRCell():New(oData,"PRODUTO"	,     ,"Produto"				 ,                             	 ,07						,.F.	   ,{|| TRB->PRODUTO			})
TRCell():New(oData,"PRODCLI"	,     ,"Cod Cliente"          	 ,                             	 ,12                        ,.F.       ,{|| TRB->PRODCLI			})
	TRCell():New(oData,"PEDICLI"	,     ,"Ordem Compra"          	 ,                             	 ,12                        ,.F.       ,{|| TRB->PEDICLI			})
TRCell():New(oData,"MATERIAL"	,     ,"Material"				 ,								 ,20						,          ,{|| TRB->MATERIAL			})
TRCell():New(oData,"INSERTO" 	,     ,"Inserto"				 ,								 ,15						,          ,{|| TRB->INSERTO			})
TRCell():New(oData,"NSALDO"		,	  ,"Saldo"			 		 ,"@E 999,999.99"				 ,10						,/*lPixel*/,{|| TRB->NSALDO	},"RIGHT",,"RIGHT")
TRCell():New(oData,"SLDACA"		,	  ,"Acabamento"				 ,"@E 999,999.99"				 ,10						,/*lPixel*/,{|| TRB->SLDACA	},"RIGHT",,"RIGHT")
TRCell():New(oData,"SLDCQ"		,	  ,"CQ"			 			 ,"@E 999,999.99"				 ,10						,/*lPixel*/,{|| TRB->SLDCQ	},"RIGHT",,"RIGHT")
TRCell():New(oData,"OBS"		,	  ,"Obs"				 	 ,								 ,10						,/*lPixel*/,{|| TRB->OBS	})
	TRCell():New(oData,"EMBAL"		,	  ,"Embalagem"				 ,								 ,10						,/*lPixel*/,{|| TRB->EMBA	})
	TRCell():New(oData,"QTPEMB"		,	  ,"Qtde p/ Emb."		 	 ,"@E 999,999.99"				 ,10						,/*lPixel*/,{|| TRB->QTPEMB	},"RIGHT",,"RIGHT")
	TRCell():New(oData,"QTEMBA"		,	  ,"Qtde de Emb."		 	 ,"@E 999,999.99"				 ,10						,/*lPixel*/,{|| TRB->QTEMBA	},"RIGHT",,"RIGHT")
	TRCell():New(oData,"RECURSO"	,	  ,"Recurso"		 	 	 ,								 ,20						,/*lPixel*/,{|| TRB->RECURSO			})

oReport:Section(1):SetUseQuery(.F.) // Novo compomente tReport para adcionar campos de usuario no relatorio qdo utiliza query
oReport:Section(2):SetUseQuery(.F.) // Novo compomente tReport para adcionar campos de usuario no relatorio qdo utiliza query
oReport:Section(3):SetUseQuery(.F.) // Novo compomente tReport para adcionar campos de usuario no relatorio qdo utiliza query
oReport:Section(4):SetUseQuery(.F.) // Novo compomente tReport para adcionar campos de usuario no relatorio qdo utiliza query

Pergunte(oReport:uParam,.F.)

oReport:Section(1):SetUseQuery(.F.) // Novo compomente tReport para adcionar campos de usuario no relatorio qdo utiliza query
oReport:Section(2):SetUseQuery(.F.) // Novo compomente tReport para adcionar campos de usuario no relatorio qdo utiliza query
oReport:Section(3):SetUseQuery(.F.) // Novo compomente tReport para adcionar campos de usuario no relatorio qdo utiliza query
oReport:Section(4):SetUseQuery(.F.) // Novo compomente tReport para adcionar campos de usuario no relatorio qdo utiliza query

Return(oReport)



Static Function PA226B(oReport,cAliasQry,oPedNEnt,oProduto,oCliente,oData)

Local dData     := CtoD("  /  /  ")
Local cNumPed   := ""
Local cNumCli   := ""
Local nTotVen   := 0
Local nTotEnt   := 0
Local nFirst    := 0
Local nValor    := 0
Local cQuebra	:= ""
Local nMoeda    := 1
Local nSection  := IIf(isBlind(), val(SX4->X4_ORDEM), oReport:Section(1):GetOrder())
Local oSecao    := oReport:Section(nSection)
Local cTrfun 

Private oReport:nLineHeight  := 60
Private cNum		:= ""
Private cProduto	:= ""
Private cCli		:= ""
Private dEntreg 	:= CtoD("  /  /  ")
Private cVde    	:= ""

//oSecao:Cell("NSALDO" ):SetBlock({|| nSaldo})

If nSection == 1			// Por Pedido
	cQuebra := "NUM = cNum"
	TRFunction():New(oPedNEnt:Cell("NSALDO"		),"cTrfun","SUM",/*oBreak*/,/*cTitle*/,PesqPict("SC6","C6_VALOR"),/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	
ElseIf nSection == 2		// Por Produto
	cQuebra := "PRODUTO = cProduto"

	TRFunction():New(oProduto:Cell("NSALDO"		),"cTrfun","SUM",/*oBreak*/,/*cTitle*/,                          ,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)

ElseIf nSection == 3		// Por Cliente
	cQuebra := "CLIENTE+LOJA = cCli"
	TRFunction():New(oCliente:Cell("NSALDO"		),"cTrfun","SUM",/*oBreak*/,/*cTitle*/,PesqPict("SC6","C6_VALOR"),/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	
ElseIf nSection == 4		// Por Data de Entrega
	cQuebra := "DATENTR = dEntreg"
	TRFunction():New(oData:Cell("NSALDO"	),"cTrfun","SUM",/*oBreak*/,/*cTitle*/,PesqPict("SC6","C6_VALOR"),/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	
EndIf

oReport:SetTitle(oReport:Title() + " - " + IIF(nSection == 1,"Por Pedido"		,;
IIF(nSection==2,"Por Produto"					,;
IIF(nSection==3,"Por Cliente","Por Dt.Entrega"))))

oSecao:SetHeaderPage() //Г Impressao do Cabecalho no top da pagina


//oSecao:Cell("NSALDO")	:SetPicture("@E 999,999,999.99")
//oSecao:Cell("SALDO")	:SetPicture("@E 999,999,999.99")
//oSecao:Cell("SLDACA")	:SetPicture("@E 999,999,999.99")
//oSecao:Cell("SLDCQ")	:SetPicture("@E 999,999,999.99")

MakeSqlExpr(oReport:uParam) //Г Transforma parametros Range em expressao SQL

TRPosition():New(oSecao,"SA1",1,{|| xFilial("SA1")+TRB->CLIENTE+TRB->LOJA })
TRPosition():New(oSecao,"SB1",1,{|| xFilial("SA3")+TRB->PRODUTO })
TRPosition():New(oSecao,"SF4",1,{|| xFilial("SF4")+TRB->TES })
TRPosition():New(oSecao,"SC6",1,{|| xFilial("SC6")+TRB->NUM+TRB->ITEM+TRB->PRODUTO })

Processa({|| PA226C(oReport,cAliasQry,nSection,oSecao)},"Gerando Tabela de Trabalho. Aguarde...")//Г Gera Tabela Temporaria para impressao

//Impressao do Relatorio

dbSelectArea("TRB")
dbGoTop()

oReport:SetMeter(RecCount())		// Total de elementos da regua

nFirst := 0
_nCont := 0
oSecao:Init()

While !oReport:Cancel() .And. !Eof()
	
	//Г Verifica campo para quebra									 Г
	cNum	:= NUM
	cProduto:= PRODUTO
	cCli	:= CLIENTE+LOJA
	dEntreg := DATENTR
	
	//Г Variaveis Totalizadoras     		    					 Г
	
	If (nFirst = 0 .And. nSection != 4) .Or. nSection == 4
				
		//Г Seleciona celulas do cabecalho da linha
		
		Do Case
			Case nSection = 1    				// Por Pedido
				oSecao:Cell("NUM"		):Show()
				oSecao:Cell("ITEM"		):Show()
				oSecao:Cell("CLIENTE"	):Show()
				oSecao:Cell("TP"		):Show()
				oSecao:Cell("LOJA"		):Show()
				oSecao:Cell("PRODUTO"	):Show()
				oSecao:Cell("PRODCLI"	):Show()
				oSecao:Cell("DATENTR"	):Show()
			Case nSection = 2					// Por Produto
				oSecao:Cell("PRODUTO"	):Show()
				oSecao:Cell("PRODCLI"	):Show()
				oSecao:Cell("PEDICLI"	):Show()
				oSecao:Cell("DATENTR"	):Show()
				oSecao:Cell("CLIENTE"	):Show()
				oSecao:Cell("LOJA"		):Show()
				oSecao:Cell("NUM"		):Show()
				oSecao:Cell("ITEM"		):Show()
				oSecao:Cell("TP"		):Show()
				oSecao:Cell("MATERIAl"	):Show()
				oSecao:Cell("INSERTO"	):Show()
				oSecao:Cell("SLDACA"	):Show()
				oSecao:Cell("SLDCQ"		):Show()
			Case nSection = 3					// Por Cliente
				oSecao:Cell("CLIENTE"	):Show()
				oSecao:Cell("LOJA"		):Show()
				oSecao:Cell("NUM"		):Show()
				oSecao:Cell("ITEM"		):Show()
				oSecao:Cell("TP"		):Show()
				oSecao:Cell("PRODUTO"	):Show()
				oSecao:Cell("PRODCLI"	):Show()
				oSecao:Cell("DATENTR"	):Show()
			Otherwise					// Por Data de Entrega
				If cNumPed+cNumCli+DtoS(dData) == NUM+CLIENTE+DtoS(DATENTR)
					oSecao:Cell("DATENTR"	):Show()
					oSecao:Cell("CLIENTE"	):Show()
					oSecao:Cell("LOJA"		):Show()
					oSecao:Cell("NUM"		):Show()
				Else
					oSecao:Cell("DATENTR"	):Show()
					oSecao:Cell("CLIENTE"	):Show()
					oSecao:Cell("LOJA"		):Show()
					oSecao:Cell("NUM"		):Show()
				EndIf
				cNumPed := NUM
				cNumCli := CLIENTE
				dData   := DATENTR
				
				oSecao:Cell("ITEM"		):Show()
				oSecao:Cell("TP"		):Show()
				oSecao:Cell("PRODUTO"	):Show()
				oSecao:Cell("PRODCLI"	):Show()
		EndCase
		
		IF nFirst = 0 .And. nSection != 4
			nFirst := 1
		Endif
		
	Else
		Do Case
			Case nSection = 1    				// Por Pedido
				oSecao:Cell("NUM"		):Show()
				oSecao:Cell("ITEM"		):Show()
				oSecao:Cell("TP"		):Show()
				oSecao:Cell("CLIENTE"	):Show()
				oSecao:Cell("LOJA"		):Show()
				oSecao:Cell("PRODUTO"	):Show()
				oSecao:Cell("PRODCLI"	):Show()
				oSecao:Cell("DATENTR"	):Show()
			Case nSection = 2					// Por Produto
				oSecao:Cell("PRODUTO"	):Show()
				oSecao:Cell("PRODCLI"	):Show()
				oSecao:Cell("PEDICLI"	):Show()
				oSecao:Cell("DATENTR"	):Show()
				oSecao:Cell("CLIENTE"	):Show()
				oSecao:Cell("LOJA"		):Show()
				oSecao:Cell("NUM"		):Show()
				oSecao:Cell("ITEM"		):Show()
				oSecao:Cell("TP"		):Show()
				oSecao:Cell("MATERIAl"	):Show()
				oSecao:Cell("INSERTO"	):Show()
				oSecao:Cell("SLDACA"	):Show()
				oSecao:Cell("SLDCQ"		):Show()
			Case nSection = 3					// Por Cliente
				oSecao:Cell("CLIENTE"	):Show()
				oSecao:Cell("LOJA"		):Show()
				oSecao:Cell("NUM"		):Show()
				oSecao:Cell("ITEM"		):Show()
				oSecao:Cell("TP"		):Show()
				oSecao:Cell("PRODUTO"	):Show()
				oSecao:Cell("PRODCLI"	):Show()
				oSecao:Cell("DATENTR"	):Show()
		EndCase
		
	EndIf
	
	oSecao:PrintLine()
		
	dbSelectArea("TRB")
	dbSkip()

	_nCont ++
	
	oReport:IncMeter()
	
	//Г Imprime o Total ou linha divisora conforme a quebra		     Г
	If !&cQuebra

/*		
		If _nCont > 1
			nFirst  := 0
			oReport:nLineHeight  := 01
	
			oSecao:SetTotalText(IIF(nSection == 1,"Total do Pedido" + " " + cNum,	;
			IIF(nSection == 2,"Total do Produto" + " " + cProduto,;					//
			IIF(nSection == 3,"Total do Cliente" + " " + cCli,"Total da Dt.Entrega" + " " + DTOC(dEntreg) ))))
		
			oReport:SkipLine(1)
		
			// Finaliza Secao
	//		If nSection <> 3 .And. nSection <> 4 .And. nSection <> 1
				oSecao:Finish()
				oSecao:Init()
	//		EndIf
			oReport:nLineHeight  := 60
		Else */
			nFirst  := 0
		
			_oTrFun := oReport:GetFunction ("cTrfun") //Retorna o nome do objeto da classe TRFunction
			_oTrFun:ResetSection() //Zera o totalizador da secao
			
			oReport:ThinLine()
//		Endif	
		_nCont := 0
		
	Endif
	
	dbSelectArea("TRB")
	
EndDo

//Г Finaliza Relatorio                                           Г
oSecao:SetPageBreak()

//Г Fecha tabela de trabalho                                     Г
dbSelectArea("TRB")
dbCloseArea()

//Г Restaura Tabelas                                             Г
dbSelectArea(cAliasQry)
dbClosearea()
dbSelectArea("SC6")
dbSetOrder(1)

Return


Static Function PA226C(oReport,cAliasQry,nSection,oSecao) //Cria Arquivo de Trabalho

Local aCampos   := {}
Local aTam      := ""
Local nX        := 0
Local nValor	:= 0
Local cFilTrab  := ""

cFilSA1        := ""
cFilSB1        := ""
cFilSF4        := ""
cFilSC6        := ""

//Г Define array para arquivo de trabalho                        Г
aTam:=TamSX3("C6_FILIAL")
AADD(aCampos,{ "FILIAL"    ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_NUM")
AADD(aCampos,{ "NUM"       ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C5_EMISSAO")
AADD(aCampos,{ "EMISSAO"   ,"D",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_CLI")
AADD(aCampos,{ "CLIENTE"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("A1_NOME")
AADD(aCampos,{ "NOMECLI"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_LOJA")
AADD(aCampos,{ "LOJA"      ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_ENTREG")
AADD(aCampos,{ "DATENTR"   ,"D",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_ITEM")
AADD(aCampos,{ "ITEM"      ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_PEDAMOS")
AADD(aCampos,{ "TIPO"      ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_PRODUTO")
AADD(aCampos,{ "PRODUTO"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_CPROCLI")
AADD(aCampos,{ "PRODCLI"   ,"C",aTam[1],aTam[2] } )
	aTam:=TamSX3("C6_PEDCLI")
	AADD(aCampos,{ "PEDICLI"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_DESCRI")
AADD(aCampos,{ "DESCRICAO" ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_QTDVEN")
AADD(aCampos,{ "QUANTIDADE","N",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_QTDENT")
AADD(aCampos,{ "ENTREGUE"  ,"N",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_TES")
AADD(aCampos,{ "TES"       	,"C",aTam[1],aTam[2] } )
AADD(aCampos,{ "MATERIAL"  	,"C",20,0 } )
AADD(aCampos,{ "INSERTO"  	,"C",20,0 } )
AADD(aCampos,{ "SLDACA"  	,"N",12,2 } )
AADD(aCampos,{ "SLDCQ"  	,"N",12,2 } )
AADD(aCampos,{ "OBS"  		,"C",10,0 } )
AADD(aCampos,{ "NSALDO"  	,"N",12,2 } )
	AADD(aCampos,{ "EMBA"  		,"C",20,0 } )
	AADD(aCampos,{ "QTPEMB"  	,"N",9,2 } )
	AADD(aCampos,{ "QTEMBA"  	,"N",9,2 } )
	AADD(aCampos,{ "RECURSO"  	,"C",20,0 } )

If len(oSecao:GetAdvplExp("SA1")) > 0
	cFilSA1 := oSecao:GetAdvplExp("SA1")
EndIf
If len(oSecao:GetAdvplExp("SB1")) > 0
	cFilSB1 := oSecao:GetAdvplExp("SB1")
EndIf
If len(oSecao:GetAdvplExp("SF4")) > 0
	cFilSF4 := oSecao:GetAdvplExp("SF4")
EndIf
If len(oSecao:GetAdvplExp("SC6")) > 0
	cFilSC6 := oSecao:GetAdvplExp("SC6")
EndIf

//Г Cria arquivo de Trabalho                                     Г
cArqTrab := CriaTrab(aCampos,.T.)
dbUseArea(.T.,,cArqTrab,"TRB",.T.,.F.)

dbSelectArea("TRB")
Do Case
	Case nSection = 1
		IndRegua("TRB",cArqTrab,"FILIAL+NUM+ITEM+PRODUTO",,,"Selecionando Registros...")
	Case nSection = 2
		IndRegua("TRB",cArqTrab,"FILIAL+PRODUTO+NUM+ITEM",,,"Selecionando Registros...")
	Case nSection = 3
		IndRegua("TRB",cArqTrab,"FILIAL+CLIENTE+LOJA+NUM+ITEM",,,"Selecionando Registros...")
	Case nSection = 4
		IndRegua("TRB",cArqTrab,"FILIAL+DTOS(DATENTR)+NUM+ITEM",,,"Selecionando Registros...")
EndCase

TRB->(dbGoTop())

//Г Verifica o Filtro                                            Г
SC6->(dbSetOrder(1))

_cPed := "("
For Ax:= 1 To Len(MV_PAR17)
	If Substr(MV_PAR17,AX,1) != "*"
		If _cPed == "("
			_cPed += "'"+Substr(MV_PAR17,AX,1)
		Else
			_cPed += "','"+Substr(MV_PAR17,AX,1)
		Endif
	Endif
Next AX

_cPed += "')"

aStru  := SC6->(dbStruct())

cWhere := "%"
cWhere += "AND C6_BLQ = '  '"
cWhere += "AND C6_PEDAMOS IN "+_cPed+""
cWhere += "%"

//ГPonto de entrada para tratamento do filtro do usuario.Г

If ExistBlock("F680QRY")
	cQueryAdd := ExecBlock("F680QRY", .F., .F., {aReturn[7]})
	If ValType(cQueryAdd) == "C"
		cWhere += " AND ( " + cQueryAdd + ")"
	EndIf
EndIf

oSecao:BeginQuery()
BeginSql Alias cAliasQry
	SELECT SC6.*
	FROM %Table:SC6% SC6
	WHERE C6_FILIAL = %xFilial:SC6%
	AND C6_NUM >= %Exp:mv_par01% AND C6_NUM <= %Exp:mv_par02%
	AND C6_PRODUTO >= %Exp:mv_par03% AND C6_PRODUTO <= %Exp:mv_par04%
	AND C6_CLI >= %Exp:mv_par05% AND C6_CLI <= %Exp:mv_par06%
	AND C6_LOJA >= %Exp:mv_par07% AND C6_LOJA <= %Exp:mv_par08%
	AND C6_ENTREG >= %Exp:DtoS(mv_par09)% AND C6_ENTREG <= %Exp:DtoS(mv_par10)%
	AND SC6.%notdel%
	%Exp:cWhere%
	ORDER BY C6_FILIAL,C6_NUM,C6_ITEM,C6_PRODUTO
EndSql
oSecao:EndQuery()

If len(oSecao:GetAdvplExp("SA1")) > 0
	cFilSA1 := oSecao:GetAdvplExp("SA1")
EndIf
If len(oSecao:GetAdvplExp("SA3")) > 0
	cFilSA3 := oSecao:GetAdvplExp("SA3")
EndIf
If len(oSecao:GetAdvplExp("SF4")) > 0
	cFilSF4 := oSecao:GetAdvplExp("SF4")
EndIf

(cAliasQry)->(dbGoTop())

oReport:SetMeter(RecCount())     // Total de Elementos da Regua

Private _aMaterial := {}
Private _aInserto  := {}
Private _aEstoque  := {}

While !oReport:Cancel() .And. (cAliasQry)->(!Eof()) .And. (cAliasQry)->C6_FILIAL == xFilial("SC6")
	
	If !Empty(cFilSC6) .And. !(&cFilSC6)
		(cAliasQry)->(dbSkip())
		Loop
	EndIf
	
	SA1->(dbSetOrder(1))
	SA1->(dbSeek( xFilial()+ (cAliasQry)->C6_CLI + (cAliasQry)->C6_LOJA ))
	
		If MV_PAR20 = 2
			If SA1->A1_TIPO = 'X'
				(cAliasQry)->(dbSkip())
				Loop
			EndIf
		ElseIf  MV_PAR20 = 3
			If SA1->A1_TIPO != 'X'
				(cAliasQry)->(dbSkip())
				Loop
			EndIf		
		Endif

	// Verifica filtro do usuario
	If !Empty(cFilSA1) .And. !(&cFilSA1)
		(cAliasQry)->(dbSkip())
		Loop
	EndIf
	
	SB1->(dbSetOrder(1))
	SB1->(dbseek(xFilial("SB1")+(cAliasQry)->C6_PRODUTO))
	
	If 	SB1->B1_GRUPO < MV_PAR13 .Or. SB1->B1_GRUPO > MV_PAR14 .Or.;
		SB1->B1_SUBGR < MV_PAR15 .Or. SB1->B1_SUBGR > MV_PAR16 .Or.;
		SB1->B1_DESC < MV_PAR18 .Or. SB1->B1_DESC > MV_PAR19
		(cAliasQry)->(dbSkip())
		Loop
	EndIf
	
		_cRecurso := Alltrim(Posicione("SX5",1,xFilial("SX5")+'ZA'+SB1->B1_9RECURS,"X5_DESCRI"))

	If !Empty(cFilSB1) .And. !(&cFilSB1)
		(cAliasQry)->(dbSkip())
		Loop
	EndIf
	
	SF4->(dbSetOrder(1))
	SF4->(dbSeek( xFilial(("SF4"))+(cAliasQry)->C6_TES ))
	
	// Verifica filtro do usuario
	If !Empty(cFilSF4) .And. !(&cFilSF4)
		(cAliasQry)->(dbSkip())
		Loop
	EndIf
	
	SC5->(dbSetOrder(1))
	SC5->(dbSeek( xFilial(("SC5"))+(cAliasQry)->C6_NUM ))
	
	dbSelectArea(cAliasQry)
	
	//Г Verifica se esta dentro dos parametros						 Г
	
	If ((C6_QTDENT < C6_QTDVEN .And. MV_PAR11 == 1) .Or. (MV_PAR11 == 2)).And.;
		((SF4->F4_DUPLIC == "S" .And. MV_PAR12 == 1) .Or. (SF4->F4_DUPLIC == "N".And. MV_PAR12 == 2).Or.(MV_PAR12 == 3));
		.And. At(SC5->C5_TIPO,"DB") = 0
			
		_nPosMat  := aScan(_aMaterial,{|x| x[1] == (cAliasQry)->C6_PRODUTO})
		If _nPosMat = 0
			VerEstrut(1)
		Endif
		
		_nPosIns  := aScan(_aInserto,{|x| x[1] == (cAliasQry)->C6_PRODUTO})
		If _nPosIns = 0
			VerEstrut(2)
		Endif
		
		_nPosEst  := aScan(_aEstoque,{|x| x[1] == (cAliasQry)->C6_PRODUTO})
		If _nPosEst = 0
			AADD(_aEstoque,{(cAliasQry)->C6_PRODUTO,0,0})
			VerEstrut(3)
		Endif
				
		_bSee3    := {|x| x[1] == (cAliasQry)->C6_PRODUTO}
		_nPosRe3  := aScan(_aEstoque,_bSee3)
			
		dbSelectArea("TRB")                          
		RecLock("TRB",.T.)
		Replace FILIAL     With (cAliasQry)->C6_FILIAL
		Replace NUM        With (cAliasQry)->C6_NUM
		Replace EMISSAO    With SC5->C5_EMISSAO
		Replace CLIENTE    With (cAliasQry)->C6_CLI
		Replace NOMECLI    With SA1->A1_NOME
		Replace LOJA       With (cAliasQry)->C6_LOJA
		Replace DATENTR    With (cAliasQry)->C6_ENTREG
		Replace ITEM       With (cAliasQry)->C6_ITEM
		Replace TIPO       With (cAliasQry)->C6_PEDAMOS
		Replace PRODUTO    With (cAliasQry)->C6_PRODUTO
		Replace PRODCLI    With (cAliasQry)->C6_CPROCLI
			Replace PEDICLI    With (cAliasQry)->C6_PEDCLI
		Replace DESCRICAO  With (cAliasQry)->C6_DESCRI
		Replace QUANTIDADE With (cAliasQry)->C6_QTDVEN
		Replace ENTREGUE   With (cAliasQry)->C6_QTDENT
		Replace TES        With (cAliasQry)->C6_TES
		Replace NSALDO     With (cAliasQry)->C6_QTDVEN - (cAliasQry)->C6_QTDENT		
		Replace SLDACA     With _aEstoque[_nPosRe3][2]
		Replace SLDCQ      With _aEstoque[_nPosRe3][3]
//		Replace OBS      	With "__________________________________________________"
		
		_bSee1    := {|x| x[1] == (cAliasQry)->C6_PRODUTO}
		_nPosRe1  := aScan(_aMaterial,_bSee1)
		_cMat     := " "
		If _nPosRe1 > 0
			For M := 2 to Len(_aMaterial[_nPosRe1])
				If M > 2
					_cMat += ";"
				Endif
				_cMat += Alltrim(_aMaterial[_nPosRe1][M])
			Next M
		Endif
		Replace MATERIAL     With Alltrim(_cMat)
		
		_bSee2    := {|x| x[1] == (cAliasQry)->C6_PRODUTO}
		_nPosRe2  := aScan(_aInserto,_bSee2)
		_cIns     := " "
		If _nPosRe2 > 0
			For I := 2 to Len(_aInserto[_nPosRe2])
				If I > 2
					_cIns += ";"
				Endif
				_cIns += Alltrim(_aInserto[_nPosRe2][I])
			Next I
		Endif
		Replace INSERTO     With Alltrim(_cIns)

			_cEmba := ''
			_nQtpEmb := _nQtEmba := 0
			SZ2->(dbSetOrder(8))
			If SZ2->(msSeek(xFilial("SZ2")+(cAliasQry)->C6_CLI + (cAliasQry)->C6_LOJA + (cAliasQry)->C6_CPROCLI+(cAliasQry)->C6_PEDCLI+"1"))
				_cEmba 		:= SZ2->Z2_CODEMB
				_nQtpEmb 	:= SZ2->Z2_QTPEMB
				_nQtEmba 	:= ((cAliasQry)->C6_QTDVEN - (cAliasQry)->C6_QTDENT) / _nQtpEmb
			Endif

			Replace EMBA		With _cEmba
			Replace QTPEMB		With _nQtpEmb
			Replace QTEMBA		With _nQtEmba
			Replace RECURSO		With _cRecurso
		MsUnLock()
	Endif
	
	(cAliasQry)->(dbSkip())
	
	oReport:IncMeter()
	
EndDo

dbSelectArea(cAliasQry)
FErase(cFilTrab+OrdBagExt())

Return


Static Function VerEstrut(_nOpc)

dbSelectArea("SG1")
dbSetOrder(1)
If dbSeek(xFilial("SG1")+(cAliasQry)->C6_PRODUTO)
	
	_cProd   := SG1->G1_COD
	nNivel   := 2
	
	dbSelectArea("SB1")
	dbSeek(xFilial("SB1")+_cProd)
	
	NECESC6(_cProd,IF(SB1->B1_QB==0,1,SB1->B1_QB),nNivel,IF(SB1->B1_QB==0,1,SB1->B1_QB),SB1->B1_OPC,SB1->B1_REVATU,_nOpc)
	
Endif

Return


Static Function NECESC6(_cProd,_nQtPai,nNivel,_nQtBase,_cOpc,_cRev,_nOpc)

Local _nReg := 0
Local _nRegTrb := 0

dbSelectArea("SG1")
dbSetOrder(1)
While !Eof() .And. SG1->G1_FILIAL + SG1->G1_COD == xFilial("SG1") + _cProd
	
	_nReg := Recno()
	
	_cGrupo := ""
	If _nOpc = 1
		_cGrupo := "PIC /MPVZ/MPC /MPL "
	ElseIf _nOpc = 2
		_cGrupo := "MPIM/PIPM"
	Endif
	
	nQuantItem := ExplEstr(_nQtPai,,_cOpc,_cRev)
	dbSelectArea("SG1")
	dbSetOrder(1)
	
		//	If nQuantItem > 0
		
		dbSelectArea("SB1")
		aAreaSB1:=GetArea()
		dbSeek(xFilial("SB1")+SG1->G1_COMP)
		
		_nRegTRb := Recno()
		
		If _nOpc < 3
			
			If SB1->B1_GRUPO $ _cGrupo
				
				If _nOpc = 1 //Material
					_bSee1    := {|x| x[1] == (cAliasQry)->C6_PRODUTO}
					_nPosRe1  := aScan(_aMaterial,_bSee1)
					
					If _nPosRe1 = 0
						AADD(_aMaterial,{(cAliasQry)->C6_PRODUTO,SG1->G1_COMP})
					Else
						AADD(_aMaterial[_nPosRe1],SG1->G1_COMP)
					Endif
				ElseIf _nOpc = 2 //Inserto
					_bSee2    := {|x| x[1] == (cAliasQry)->C6_PRODUTO}
					_nPosRe2  := aScan(_aInserto,_bSee2)
					
					If _nPosRe2 = 0
						AADD(_aInserto,{(cAliasQry)->C6_PRODUTO,SG1->G1_COMP})
					Else
						AADD(_aInserto[_nPosRe2],SG1->G1_COMP)
					Endif
				Endif
			Endif
			
		ElseIf _nOpc = 3

			_bSee3    := {|x| x[1] == (cAliasQry)->C6_PRODUTO}
			_nPosRe3  := aScan(_aEstoque,_bSee3)
			
/*			If _nPosRe3 = 0
				AADD(_aEstoque,{(cAliasQry)->C6_PRODUTO,0,0})
				_nPosRe3  := aScan(_aEstoque,_bSee3)			
			Endif	
  */
			If SB1->B1_LOCPAD $ "20" //Acabamento

				dbSelectArea("SB2")
				dbSetOrder(1)
				If dbSeek(xFilial("SB2")+SB1->B1_COD+SB1->B1_LOCPAD)					
					_aEstoque[_nPosRe3][2] := SB2->B2_QATU
				Endif
			Endif		

			dbSelectArea("SB2")
			dbSetOrder(1)
			If dbSeek(xFilial("SB2")+(cAliasQry)->C6_PRODUTO+"98")
				_aEstoque[_nPosRe3][3] := SB2->B2_QATU
			Endif				

		Endif
		RestArea(aAreaSB1)
		
		dbSelectArea("SG1")
		dbSetOrder(1)
		dbSeek(xFilial("SG1")+SG1->G1_COMP)
		IF Found()
			dbSelectArea("SB1")
			dbSeek(xFilial("SB1")+SG1->G1_COD)
			
			NECESC6(SG1->G1_COD,IF(SB1->B1_QB==0,1,SB1->B1_QB),nNivel,IF(SB1->B1_QB==0,1,SB1->B1_QB),SB1->B1_OPC,SB1->B1_REVATU,_nOpc)
		EndIf
		
		dbSelectArea("SG1")
		dbGoto(_nReg)
		
		dbSelectArea("SG1")
		//	Endif
	dbSkip()
EndDo

Return
