#Include 'Protheus.ch'
#INCLUDE "FWBROWSE.CH"
#Include "TOPCONN.CH"
#include "TOTVS.CH"

#DEFINE 	CRLF	chr(13)+chr(10)

/*/{Protheus.doc} reajuste

Função de reajuste da tabela de preços.

@author Rodrigo feitosa
@since 11/10/2013
@version P11

Atualizacao em 22/05/2015 Juailson Semar
NOVA VERSAO - MOSTRANDO PRECOS DE OBRA E ATUALIZANDO POR Preco Tabela, Preco Obra e Ambos.

/*/
User Function MZ0133()   // U_MZ0133()

	Local 	c_PICTURE := ""

	Private cCliDe 	:= space(TAMSX3("ZI_CLIENTE")[1])
	Private cCliAte 	:= cCliDe
	Private cLojaDe	:= space(TAMSX3("ZI_LOJA")[1])
	Private cLojaAte	:= cLojaDe
	Private cMunDe	:= space(TAMSX3("A1_MUN")[1])
	Private cMunAte	:= cMunDe
	Private cEstDe	:= space(TAMSX3("A1_EST")[1])
	Private cEstAte	:= cEstDe
	Private cFilDe	:= space(TAMSX3("A1_FILIAL")[1])
	Private cFilAte	:= cFilDe
	Private cProdDe	:= space(TAMSX3("ZI_PRODUTO")[1])
	Private cProdAte	:= cProdDe
	Private cVendDe	:= space(TAMSX3("A1_VEND")[1])
	Private cVendAte	:= cVendDe
	Private _cGrpPrDe	:= _cGrpPrAte	:= space(6)//TAMSX3("A1_VEND")[1])
	Private _cMesoDe	:= _cMesoAte	:= space(TAMSX3("A1_YMESCR")[1])
	Private _cMicrDe	:= _cMicrAte	:= space(TAMSX3("A1_YMICRE")[1])
	Private aItensRad	:= {"Valor","Percentual","Alinhamento"}
	Private aItensRea	:= {"Acréscimo","Decréscimo"}
	//Juailson - Semar - Preco Cif Descarga/Desconto Descarga -> "ZI_DESCCID","ZI_PRECOD"
	Private _aCampos 	:= {"ZI_LIBER","ZI_DTBLOQ","ZI_PRODUTO","ZI_DESC","ZI_DESCON","ZI_PRECO",/*"ZI_DESCCID",*/"ZI_PRECOD","ZI_PRECOF","ZI_PGER","ZI_PRCUNIT","ZI_DESCONF","ZI_DTREAJ","ZI_DTVIGEN","ZI_USRINC"}
	Private _aZA2Campos := {"ZA2_LIBER","ZA2_DTBLOQ","ZA2_PRODUT","ZA2_DESPRO "," ","ZA2_PRC01",/*"ZI_DESCCID",*/"ZA2_PRC01D","ZA2_PRC01F","ZA2_PRCGER","ZA2_PRUNIT"," "," ","ZA2_DTVIG ","ZA2_USRINC"}
	Private aTam		:= {}
	Private aPosObj	:= {},aPosObj2 	:= {},aPosObj3	:= {}
	Private aPosObj4	:= {},aPosObj5	:= {},aPosObj6	:= {}
	Private aPosObj7 	:= {},aPosObj8	:= {},aPosObj9	:= {}
	Private aPosObj10	:= {},aPosObj11	:= {},aPosObj12	:= {}
	Private aPosObj13	:= {},aPosObj14	:= {},aPosObj15	:= {}
	Private aPosObj16	:= {},aPosObj17	:= {},aPosObj18	:= {}
	Private nCif		:= 0
	Private nCifD		:= 0
	Private nFob		:= 0
	Private nUni		:= 0
	Private nGer		:= 0
	Private nTipo		:= 1
	Private nAcres	:= 1
	Private aHeader1	:= {}
	Private aHeader2	:= {}
	Private aFiltro  	:= {}
	Private cTable   	:= "SZH"
	Private cTableIt	:= "SZI"
	Private cTableQry	:= "ZRJ"
	Private oBrw,oDlg
	Private aDados	:= {}
	Private aItens	:= {{"","","","","","","","","","","","","","","",""}}
	Private oGetCif,oGetCifD,oGetFob,oGetUni,oGetGer,oRad2
	Private lAcresc,lPerc,lAlinha
	Private oMenu01
	Private cCadastro  := "Clientes"
	Private aRotina
	Private _cGrAprov := ""
	Private cPerg2 := "MZ0133SM"

	_cGrAprov:= GETMV("MZ_GRAPROV")

	SX3->(DbSetOrder(1))
	If SX3->(msSeek(cTable))
		While SX3->X3_ARQUIVO == cTable
			if SX3->X3_BROWSE == "S" .and. X3USO(SX3->X3_USADO)
				AAdd(aHeader1,{ALLTRIM(SX3->X3_TITULO),;
				SX3->X3_TAMANHO,;
				SX3->X3_CAMPO,;
				ALLTRIM(SX3->X3_PICTURE)})
			endif
			SX3->(DbSkip())
		EndDo
	endif

	SX3->(dbSetOrder(2))
	SX3->(dbGoTop())
	FOR AZ:= 1 TO Len(_aCampos)
		If SX3->(msSeek(_aCampos[AZ]))
			If  X3USO(SX3->X3_USADO)

				//Colocar mascara para data - Juailson - Semar 06/03/2015
				if SX3->X3_TIPO == "D"
					c_PICTURE := "@D"
				else
					c_PICTURE := SX3->X3_PICTURE
				endif

				AAdd(aHeader2,{ALLTRIM(SX3->X3_TITULO),;
				SX3->X3_TAMANHO,;
				SX3->X3_CAMPO,;
				/*	ALLTRIM(SX3->X3_PICTURE) */ c_PICTURE })
			Endif
		Endif
	Next AZ

	calcObjetos()

	oDlg 	:= TDialog():New(aTam[7],0,aTam[6],aTam[5],"Reajuste da Tabela de Preços",,,,,,,,,.T.)
	oGroup2 := TGroup():New(aPosObj13[1,1],aPosObj13[1,2],aPosObj13[1,3],aPosObj13[1,4],"Tabela de Preço",oDlg,,,.T.)
	oGroup3	:= TGroup():New(aPosObj2[1,1],aPosObj2[1,2],aPOsObj2[1,3],aPosObj2[1,4],"Filtro",oDlg,,,.T.)
	oGroup4	:= TGroup():New(aPosObj2[2,1],aPOsObj2[2,2],aPOsObj2[2,3],aPosObj2[2,4],"Reajuste",oDlg,,,.T.)
	oGroup5	:= TGroup():New(aPosObj3[1,1],aPosObj3[1,2],aPosObj3[1,3],aPosObj3[1,4],"Tipo",oDlg,,,.T.)
	oGroup6	:= TGroup():New(aPosObj13[2,1],aPosObj13[2,2],aPosObj13[2,3],aPosObj13[2,4],"Itens da Tabela de Preço",oDlg,,,.T.)

	oSay1	:= TSay():New(aPosObj8[2,1],aPosObj8[2,2],{|| "Do Cliente: "},oDlg,,,,,,.T.,,,aPosObj8[2,4]-aPosObj8[2,2],((aPosObj8[2,3]-aPosObj8[2,1])*0.45))
	oGet1   := TGet():New(aPosObj8[2,1]+((aPosObj8[2,3]-aPosObj8[2,1])*0.45),aPosObj8[2,2],{|u| If(PCount() > 0, cCliDe := u, cCliDe) },;
	oDlg,aPosObj8[2,4]-aPosObj8[2,2],(aPosObj8[2,3]-aPosObj8[2,1])*0.45,"@!",{|| filtro(cCliDe,"ZH_CLIENTE",1)},0,,,.F.,,.T.,;
	,.F.,,.F.,.F.,,.F.,.F.,"CLI",cCliDe,,,,)

	oSay2	:= TSay():New(aPosObj8[3,1],aPosObj8[3,2],{|| "Loja De: "},oDlg,,,,,,.T.,,,aPosObj8[3,4]-aPosObj8[3,2],((aPosObj8[3,3]-aPosObj8[3,1])*0.45))
	oGet2   := TGet():New(aPosObj8[3,1]+((aPosObj8[3,3]-aPosObj8[3,1])*0.45),aPosObj8[3,2],{|u| If(PCount() > 0, cLojaDe := u, cLojaDe) },;
	oDlg,aPosObj8[3,4]-aPosObj8[3,2],(aPosObj8[3,3]-aPosObj8[3,1])*0.45,"@!",{|| filtro(cLojaDe,"ZH_LOJA",1)},0,,,.F.,,.T.,;
	,.F.,,.F.,.F.,,.F.,.F.,"",cLojaDe,,,,)

	oSay3	:= TSay():New(aPosObj9[2,1],aPosObj9[2,2],{|| "Ate o Cliente: "},oDlg,,,,,,.T.,,,aPosObj9[2,4]-aPosObj9[2,2],((aPosObj9[2,3]-aPosObj9[2,1])*0.45))
	oGet3   := TGet():New(aPosObj9[2,1]+((aPosObj9[2,3]-aPosObj9[2,1])*0.45),aPosObj9[2,2],{|u| If(PCount() > 0, cCliAte := u, cCliAte) },;
	oDlg,aPosObj9[2,4]-aPosObj9[2,2],(aPosObj9[2,3]-aPosObj9[2,1])*0.45,"@!",{|| filtro(cCliAte,"ZH_CLIENTE",2)},0,,,.F.,,.T.,;
	,.F.,,.F.,.F.,,.F.,.F.,"CLI",cCliAte,,,,)

	oSay4		:= TSay():New(aPosObj9[3,1],aPosObj9[3,2],{|| "Loja Até: "},oDlg,,,,,,.T.,,,aPosObj9[3,4]-aPosObj9[3,2],((aPosObj9[3,3]-aPosObj9[3,1])*0.45))
	oGet4    	:= TGet():New(aPosObj9[3,1]+((aPosObj9[3,3]-aPosObj9[3,1])*0.45),aPosObj9[3,2],{|u| If(PCount() > 0, cLojaAte := u, cLojaAte) },;
	oDlg,aPosObj9[3,4]-aPosObj9[3,2],(aPosObj9[3,3]-aPosObj9[3,1])*0.45,"@!",{|| filtro(cLojaAte,"ZH_LOJA",2)},0,,,.F.,,.T.,;
	,.F.,,.F.,.F.,,.F.,.F.,"",cLojaAte,,,,)

	oSay5		:= TSay():New(aPosObj10[1,1],aPosObj10[1,2],{|| "Município De: "},oDlg,,,,,,.T.,,,aPosObj10[1,4]-aPosObj10[1,2],((aPosObj10[1,3]-aPosObj10[1,1])*0.45))
	oGet5    	:= TGet():New(aPosObj10[1,1]+((aPosObj10[1,3]-aPosObj10[1,1])*0.45),aPosObj10[1,2],{|u| If(PCount() > 0, cMunDe := u, cMunDe) },;
	oDlg,aPosObj10[1,4]-aPosObj10[1,2],(aPosObj10[1,3]-aPosObj10[1,1])*0.45,"@!",{|| filtro(cMunDe,"A1_MUN",1)},0,,,.F.,,.T.,;
	,.F.,,.F.,.F.,,.F.,.F.,"CC2SX1",cMunDe,,,,)

	oSay6		:= TSay():New(aPosObj11[1,1],aPosObj11[1,2],{|| "Município Até: "},oDlg,,,,,,.T.,,,aPosObj11[1,4]-aPosObj11[1,2],((aPosObj11[1,3]-aPosObj11[1,1])*0.45))
	oGet6    	:= TGet():New(aPosObj11[1,1]+((aPosObj11[1,3]-aPosObj11[1,1])*0.45),aPosObj11[1,2],{|u| If(PCount() > 0, cMunAte := u, cMunAte) },;
	oDlg,aPosObj11[1,4]-aPosObj11[1,2],(aPosObj11[1,3]-aPosObj11[1,1])*0.45,"@!",{|| filtro(cMunAte,"A1_MUN",2)},0,,,.F.,,.T.,;
	,.F.,,.F.,.F.,,.F.,.F.,"CC2SX1",cMunAte,,,,)

	oSay7		:= TSay():New(aPosObj10[2,1],aPosObj10[2,2],{|| "Estado de: "},oDlg,,,,,,.T.,,,aPosObj10[2,4]-aPosObj10[2,2],((aPosObj10[2,3]-aPosObj10[2,1])*0.45))
	oGet7    	:= TGet():New(aPosObj10[2,1]+((aPosObj10[2,3]-aPosObj10[2,1])*0.45),aPosObj10[2,2],{|u| If(PCount() > 0, cEstDe := u, cEstDe) },;
	oDlg,aPosObj10[2,4]-aPosObj10[2,2],(aPosObj10[2,3]-aPosObj10[2,1])*0.45,"@!",{|| filtro(cEstDe,"A1_EST",1)},0,,,.F.,,.T.,;
	,.F.,,.F.,.F.,,.F.,.F.,"12",cEstDe,,,,)

	oSay8		:= TSay():New(aPosObj11[2,1],aPosObj11[2,2],{|| "Estado Até: "},oDlg,,,,,,.T.,,,aPosObj11[2,4]-aPosObj11[2,2],((aPosObj11[2,3]-aPosObj11[2,1])*0.45))
	oGet8    	:= TGet():New(aPosObj11[2,1]+((aPosObj11[2,3]-aPosObj11[2,1])*0.45),aPosObj11[2,2],{|u| If(PCount() > 0, cEstAte := u, cEstAte) },;
	oDlg,aPosObj11[2,4]-aPosObj11[2,2],(aPosObj11[2,3]-aPosObj11[2,1])*0.45,"@!",{|| filtro(cEstAte,"A1_EST",2)},0,,,.F.,,.T.,;
	,.F.,,.F.,.F.,,.F.,.F.,"12",cEstAte,,,,)

	oSay9		:= TSay():New(aPosObj8[1,1],aPosObj8[1,2],{|| "Filial De: "},oDlg,,,,,,.T.,,,aPosObj8[1,4]-aPosObj8[1,2],((aPosObj8[1,3]-aPosObj8[1,1])*0.45))
	oGet9    	:= TGet():New(aPosObj8[1,1]+((aPosObj8[1,3]-aPosObj8[1,1])*0.45),aPosObj8[1,2],{|u| If(PCount() > 0, cFilDe := u, cFilDe) },;
	oDlg,aPosObj8[1,4]-aPosObj8[1,2],(aPosObj8[1,3]-aPosObj8[1,1])*0.45,"99",{|| filtro(cFilDe,"A1_FILIAL",1)},0,,,.F.,,.T.,;
	,.F.,,.F.,.F.,,.F.,.F.,"SM0",cFilDe,,,,)
	oGet9:Disable()

	oSay10		:= TSay():New(aPosObj9[1,1],aPosObj9[1,2],{|| "Filial Até: "},oDlg,,,,,,.T.,,,aPosObj9[1,4]-aPosObj9[1,2],((aPosObj9[1,3]-aPosObj9[1,1])*0.45))
	oGet10    	:= TGet():New(aPosObj9[1,1]+((aPosObj9[1,3]-aPosObj9[1,1])*0.45),aPosObj9[1,2],{|u| If(PCount() > 0, cFilAte := u, cFilAte) },;
	oDlg,aPosObj9[1,4]-aPosObj9[1,2],(aPosObj9[1,3]-aPosObj9[1,1])*0.45,"99",{|| filtro(cFilAte,"A1_FILIAL",2)},0,,,.F.,,.T.,;
	,.F.,,.F.,.F.,,.F.,.F.,"SM0",cFilAte,,,,)
	oGet10:Disable()

	oSay11		:= TSay():New(aPosObj12[1,1],aPosObj12[1,2],{|| "Produto De: "},oDlg,,,,,,.T.,,,aPosObj12[1,4]-aPosObj12[1,2],((aPosObj12[1,3]-aPosObj12[1,1])*0.45))
	oGet11    	:= TGet():New(aPosObj12[1,1]+((aPosObj12[1,3]-aPosObj12[1,1])*0.45),aPosObj12[1,2],{|u| If(PCount() > 0, cProdDe := u, cProdDe) },;
	oDlg,aPosObj12[1,4]-aPosObj12[1,2],(aPosObj12[1,3]-aPosObj12[1,1])*0.45,"@!",{|| filtro(cProdDe,"ZI_PRODUTO",1)},0,,,.F.,,.T.,;
	,.F.,,.F.,.F.,,.F.,.F.,"SB1",cProdDe,,,,)

	oSay12		:= TSay():New(aPosObj12[2,1],aPosObj12[2,2],{|| "Produto Até: "},oDlg,,,,,,.T.,,,aPosObj12[2,4]-aPosObj12[2,2],((aPosObj12[2,3]-aPosObj12[2,1])*0.45))
	oGet12    	:= TGet():New(aPosObj12[2,1]+((aPosObj12[2,3]-aPosObj12[2,1])*0.45),aPosObj12[2,2],{|u| If(PCount() > 0, cProdAte := u, cProdAte) },;
	oDlg,aPosObj12[2,4]-aPosObj12[2,2],(aPosObj12[2,3]-aPosObj12[2,1])*0.45,"@!",{|| filtro(cProdAte,"ZI_PRODUTO",2)},0,,,.F.,,.T.,;
	,.F.,,.F.,.F.,,.F.,.F.,"SB1",cProdAte,,,,)

	oSay13		:= TSay():New(aPosObj15[1,1],aPosObj15[1,2],{|| "Vendedor De: "},oDlg,,,,,,.T.,,,aPosObj15[1,4]-aPosObj15[1,2],((aPosObj15[1,3]-aPosObj15[1,1])*0.45))
	oGet13    	:= TGet():New(aPosObj15[1,1]+((aPosObj15[1,3]-aPosObj15[1,1])*0.45),aPosObj15[1,2],{|u| If(PCount() > 0, cVendDe := u, cVendDe) },;
	oDlg,aPosObj15[1,4]-aPosObj15[1,2],(aPosObj15[1,3]-aPosObj15[1,1])*0.45,"@!",;
	{|| filtro(cVendDe,"A1_VEND",1)},0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,"SA3",cVendDe,,,,)

	oSay14		:= TSay():New(aPosObj15[2,1],aPosObj15[2,2],{|| "Vendedor Até: "},oDlg,,,,,,.T.,,,aPosObj15[2,4]-aPosObj15[2,2],((aPosObj15[2,3]-aPosObj15[2,1])*0.45))
	oGet14    	:= TGet():New(aPosObj15[2,1]+((aPosObj15[2,3]-aPosObj15[2,1])*0.45),aPosObj15[2,2],{|u| If(PCount() > 0, cVendAte := u, cVendAte) },;
	oDlg,aPosObj15[2,4]-aPosObj15[2,2],(aPosObj15[2,3]-aPosObj15[2,1])*0.45,"@!",;
	{|| filtro(cVendAte,"A1_VEND",2)},0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,"SA3",cVendAte,,,,)


	oSay15		:= TSay():New(aPosObj16[1,1],aPosObj16[1,2],{|| "Grupo Preço De: "},oDlg,,,,,,.T.,,,aPosObj16[1,4]-aPosObj16[1,2],((aPosObj16[1,3]-aPosObj16[1,1])*0.45))
	oGet15    	:= TGet():New(aPosObj16[1,1]+((aPosObj16[1,3]-aPosObj16[1,1])*0.45),aPosObj16[1,2],{|u| If(PCount() > 0, _cGrpPrDe := u, _cGrpPrDe) },;
	oDlg,aPosObj16[1,4]-aPosObj16[1,2],(aPosObj16[1,3]-aPosObj16[1,1])*0.45,"@!",;
	{|| filtro(_cGrpPrDe,"A1_VEND",1)},0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,"SA3",_cGrpPrDe,,,,)

	oSay16		:= TSay():New(aPosObj16[2,1],aPosObj16[2,2],{|| "Grupo Preço Até: "},oDlg,,,,,,.T.,,,aPosObj16[2,4]-aPosObj16[2,2],((aPosObj16[2,3]-aPosObj16[2,1])*0.45))
	oGet16    	:= TGet():New(aPosObj16[2,1]+((aPosObj16[2,3]-aPosObj16[2,1])*0.45),aPosObj16[2,2],{|u| If(PCount() > 0, _cGrpPrAte := u, _cGrpPrAte) },;
	oDlg,aPosObj16[2,4]-aPosObj16[2,2],(aPosObj16[2,3]-aPosObj16[2,1])*0.45,"@!",;
	{|| filtro(_cGrpPrAte,"A1_VEND",2)},0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,"SA3",_cGrpPrAte,,,,)


	oSay17		:= TSay():New(aPosObj17[1,1],aPosObj17[1,2],{|| "Meso Região De: "},oDlg,,,,,,.T.,,,aPosObj17[1,4]-aPosObj17[1,2],((aPosObj17[1,3]-aPosObj17[1,1])*0.45))
	oGet17    	:= TGet():New(aPosObj17[1,1]+((aPosObj17[1,3]-aPosObj17[1,1])*0.45),aPosObj17[1,2],{|u| If(PCount() > 0, _cMesoDe := u, _cMesoDe) },;
	oDlg,aPosObj17[1,4]-aPosObj17[1,2],(aPosObj17[1,3]-aPosObj17[1,1])*0.45,"@!",;
	{|| filtro(_cMesoDe,"A1_YMESCR",1)},0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,"C1",_cMesoDe,,,,)

	oSay18		:= TSay():New(aPosObj17[2,1],aPosObj17[2,2],{|| "Meso Região Até: "},oDlg,,,,,,.T.,,,aPosObj17[2,4]-aPosObj17[2,2],((aPosObj17[2,3]-aPosObj17[2,1])*0.45))
	oGet18    	:= TGet():New(aPosObj17[2,1]+((aPosObj17[2,3]-aPosObj17[2,1])*0.45),aPosObj17[2,2],{|u| If(PCount() > 0, _cMesoAte := u, _cMesoAte) },;
	oDlg,aPosObj17[2,4]-aPosObj17[2,2],(aPosObj17[2,3]-aPosObj17[2,1])*0.45,"@!",;
	{|| filtro(_cMesoAte,"A1_YMESCR",2)},0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,"C1",_cMesoAte,,,,)


	oSay19		:= TSay():New(aPosObj18[1,1],aPosObj18[1,2],{|| "Micro Região De: "},oDlg,,,,,,.T.,,,aPosObj18[1,4]-aPosObj18[1,2],((aPosObj18[1,3]-aPosObj18[1,1])*0.45))
	oGet19    	:= TGet():New(aPosObj18[1,1]+((aPosObj18[1,3]-aPosObj18[1,1])*0.45),aPosObj18[1,2],{|u| If(PCount() > 0, _cMicrDe := u, _cMicrDe) },;
	oDlg,aPosObj18[1,4]-aPosObj18[1,2],(aPosObj18[1,3]-aPosObj18[1,1])*0.45,"@!",;
	{|| filtro(_cMicrDe,"A1_YMICRE ",1)},0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,"C2",_cMicrDe,,,,)

	oSay20		:= TSay():New(aPosObj18[2,1],aPosObj18[2,2],{|| "Micro Região Até: "},oDlg,,,,,,.T.,,,aPosObj18[2,4]-aPosObj18[2,2],((aPosObj18[2,3]-aPosObj18[2,1])*0.45))
	oGet20    	:= TGet():New(aPosObj18[2,1]+((aPosObj18[2,3]-aPosObj18[2,1])*0.45),aPosObj18[2,2],{|u| If(PCount() > 0, _cMicrAte := u, _cMicrAte) },;
	oDlg,aPosObj18[2,4]-aPosObj18[2,2],(aPosObj18[2,3]-aPosObj18[2,1])*0.45,"@!",;
	{|| filtro(_cMicrAte,"A1_YMICRE ",2)},0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,"C2",_cMicrAte,,,,)

	//////////////////////////////////////////////////////
	//Componentes Gráficos do grupo de valores          //
	//                                                  //
	//////////////////////////////////////////////////////
	oRad1		:= TRadMenu():New(aPosObj14[1,1],aPosObj14[1,2],aItensRad,{|u| If(PCount() > 0, nTipo := u, nTipo) },oDlg,,{|| mudouTipo()},,,;
	"Tipo de reajuste",,,aPOsObj14[1,4]-aPosObj14[1,2],10,,,,.T.)
	oRad2		:= TRadMenu():New(aPosObj14[2,1],aPosObj14[2,2],aItensRea,{|u| If(PCount() > 0, nAcres := u, nAcres) },oDlg,,{||},,,;
	"Tipo de reajuste",,,aPOsObj14[2,4]-aPosObj14[2,2],10,,,,.T.)
	oSayCif	:= TSay():New(aPosObj4[1,1],aPosObj4[1,2],{|| "CIF: "},oDlg,,,,,,.T.,,,50,8)
	oGetCif	:= TGet():New(aPosObj4[1,1]+8,aPosObj4[1,2],{|u| If(PCount() > 0, nCif := u, nCif) },oDlg,50,8,'@E 999,999.99',;
	,,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cValtoChar(nCif),,,,)
	//Juailson-Semar - Preco CIF Descarga - 23/01/15//
	//----------------------------linha, coluna
	oSayCifD := TSay():New(aPosObj4[1,1],aPosObj4[1,2]+67,{|| "CIF Descarga: "},oDlg,,,,,,.T.,,,50,8)
	oGetCifD := TGet():New(aPosObj4[1,1]+8,aPosObj4[1,2]+67,{|u| If(PCount() > 0, nCifD := u, nCifD) },oDlg,50,8,'@E 999,999.99',;
	,,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cValtoChar(nCifD),,,,)
	//
	oSayFob	:= TSay():New(aPosObj4[2,1],aPosObj4[2,2]+42,{|| "FOB: "},oDlg,,,,,,.T.,,,50,8)
	oGetFob	:= TGet():New(aPosObj4[2,1]+8,aPosObj4[2,2]+42,{|u| If(PCount() > 0, nFob := u, nFob) },oDlg,50,8,'@E 999,999.99',;
	,,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cValtoChar(nFob),,,,)
	//aPosObj5
	oSayUni	:= TSay():New(aPosObj5[1,1],aPosObj5[1,2],{|| "Unitário: "},oDlg,,,,,,.T.,,,50,8)
	oGetUni	:= TGet():New(aPosObj5[1,1]+8,aPosObj5[1,2],{|u| If(PCount() > 0, nUni := u, nUni) },oDlg,50,8,'@E 999,999.99',;
	,,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cValtoChar(nUni),,,,)
	oSayGer	:= TSay():New(aPosObj5[2,1],aPosObj5[2,2]-25,{|| "Gerência: "},oDlg,,,,,,.T.,,,50,8)
	oGetGer	:= TGet():New(aPosObj5[2,1]+8,aPosObj5[2,2]-25,{|u| If(PCount() > 0, nGer := u, nGer) },oDlg,50,8,'@E 999,999.99',;
	,,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cValtoChar(nGer),,,,)
//	oButton	:= TButton():New(aPosObj6[1,1]+(aPosObj6[1,3]-aPosObj6[1,1])*0.28,aPosObj6[1,2],"Reajustar",oDlg,{|| reajustar()},100,10,,,,.T.)
	oTFont := TFont():New('Courier new',,-14,,.T.,,,,,.T.)
	oButton	:= TButton():New(aPosObj5[2,1]+8,aPosObj4[2,2]+42,"Reajustar",oDlg,{|| reajustar()},50,10,,oTFont,,.T.)
	/*/                                                /*/

	oBrw 	:= MsBrGetDBase():New(aPosObj13[1,1]+10,aPosObj13[1,2]+5,(aPosObj13[1,4]-aPosObj13[1,2]-10),(aPosObj13[1,3]-aPosObj13[1,1]-15),,,,;
	oDlg,,,,,,,,,,,, .F., "", .T.,, .F.,,,)
	oBrw:lHScroll 	:= .F.
	oBrw:nScrollType	:= 1
	oBrw:bLDblClick	:= {|| buscaItens()}
	oBrw:bRClicked	:= {|oObj,X,Y| cliqueDireito("TP"),oMenu01:Activate( X, Y, oObj )}

	oBrw2	:= MsBrGetDBase():New(aPosObj13[2,1]+10,aPosObj13[2,2]+5,(aPosObj13[2,4]-aPosObj13[2,2]-10),(aPosObj13[2,3]-aPosObj13[2,1]-15),,,,;
	oDlg,,,,,,,,,,,, .F., "", .T.,, .F.,,,)
	oBrw2:lHScroll	:= .F.
	oBrw2:nScrollType	:= 1
	oBrw2:bRClicked	:= {|oObj,X,Y| cliqueDireito("ITP"),oMenu01:Activate( X, Y, oObj )}

	filtro("","ZH_CLIENTE",1)
	oBrw:SetArray(aDados)
	oBrw2:SetArray(aItens)

	aTst := ClassDataArr(oGet10)

	for ix:=1 to Len(aHeader1)
		cTst := "{|| aDados[oBrw:nAt,"+cValtoChar(ix)+"] }"
		oBrw:AddColumn(TCColumn():New(aHeader1[ix][1],&(cTst),aHeader1[ix][4],,,"LEFT",,.F.,.F.,,,,.F.,))
	next

	for ix:=1 to Len(aHeader2)
		cTst := "{|| aItens[oBrw2:nAt,"+cValtoChar(ix)+"] }"
		oBrw2:AddColumn(TCColumn():New(aHeader2[ix][1],&(cTst),aHeader2[ix][4],,,"LEFT",,.F.,.F.,,,,.F.,))
	next

	oDlg:Activate()

Return

/*/{Protheus.doc} filtro

Efetua a atualização do filtro da browse em tempo de execução.

@author Rodrigo feitosa
@since 11/10/2013
@version P11

/*/
Static Function filtro(cExp,cCampo,nTipo)

	Local aObraFiltro	:= {}
	Local cSQL_Obra		:= ""
	//Adicionado em 30/04/2018 por Rodrigo Feiotsa - melhorar o rendimento da query
	Local lFiltSA1
	Local lFiltSZI
	////////////////////////
	//aFiltro             //
	//[1] - Campo			 //
	//[2] - cExp1         //
	//[3] - cExp2         //
	////////////////////////
	aDados := {}
	aItens := {{"","","","","","","","","","","","","","",""}}

	nPos := aScan(aFiltro,{|x| x[1] == cCampo})
	if nPos == 0
		AAdd(aFiltro,{cCampo,if(nTipo==1,cExp," "),if(nTipo==1," ",cExp)})
	else
		aFiltro[nPos][nTipo+1] := cExp
	endif

	aSort(aFiltro,,,{|x,z| x[1]+cValtoChar(x[2]) < z[1]+cValtoChar(z[2])})

	lFiltSA1 := (aScan(aFiltro,{|x| substr(x[1],1,3) == "A1_"}) > 0)
	lFiltSZI := (aScan(aFiltro,{|x| substr(x[1],1,3) == "ZI_"}) > 0)

	cSQL := "SELECT DISTINCT ZH_CLIENTE,ZH_LOJA,ZH_NOME FROM "+RetSqlName("SZH")+" SZH "
	if lFiltSZI
		cSQL += "INNER JOIN "+RetSqlName("SZI")+" SZI ON "
		cSQL += "	ZI_CLIENTE = ZH_CLIENTE 	"
		cSQL += "	AND ZI_LOJA = ZH_LOJA		"
		cSQL += "	AND ZI_FILIAL = ZH_FILIAL	"
		cSQL += "	AND SZI.D_E_L_E_T_ = ' '	"
	endif
	if lFiltSA1
		cSQL += "INNER JOIN "+RetSqlName("SA1")+" SA1 ON "
		cSQL += "	A1_COD = ZH_CLIENTE			"
		cSQL += "	AND A1_LOJA = ZH_LOJA		"
		cSQL += "	AND SA1.D_E_L_E_T_ = ' '	"
	endif
	cSQL += " WHERE ZH_FILIAL = '"+xFilial("SZH")+"' "
	cSQL += " AND SZH.D_E_L_E_T_ = ' ' "
	for a:=1 to Len(aFiltro)
		do case
			case empty(aFiltro[a][2]) .and. !empty(aFiltro[a][3])
			cSQL += " AND "+aFiltro[a][1]+" <= '"+aFiltro[a][3]+"' "

			case empty(aFiltro[a][3]) .and. !empty(aFiltro[a][2])
			cSQL += " AND "+aFiltro[a][1]+" >= '"+aFiltro[a][2]+"' "

			case !empty(aFiltro[a][2]) .and. !empty(aFiltro[a][3])
			cSQL += " AND UPPER("+aFiltro[a][1]+") BETWEEN '"+aFiltro[a][2]+"' AND '"+aFiltro[a][3]+"' " // Normando (Semar) 10/09/2015 - Caixa alta
		endcase

	next
	cSQL += "ORDER BY ZH_CLIENTE "

	TCQUERY cSQL New Alias (cTableQry)

	DbSelectArea(cTableQry)
	(cTableQry)->(DbGoTop())
	While (cTableQry)->(!EOF())
		AAdd(aDados,{(cTableQry)->ZH_CLIENTE,(cTableQry)->ZH_LOJA,(cTableQry)->ZH_NOME})
		(cTableQry)->(DbSkip())
	end
	(cTableQry)->(DbCloseArea())

	If cEmpAnt + cFilAnt $ '0210|0211|0214'
		for a:=1 to Len(aFiltro) // A T E N C A O  ESSA ROTINA É PARA FAZER COPIA DO ARRAY, POIS SE FIZER aObraFiltro := p_aFiltro, altera o aFiltro.
			AAdd(aObraFiltro,{aFiltro[a][1],;
			aFiltro[a][2],;
			aFiltro[a][3]})
		next

		for a:=1 to Len(aObraFiltro)

			if      aObraFiltro[a][1] == "ZH_CLIENTE"
				aObraFiltro[a][1] := "ZA2_CLIENT"
				cNomeCampo := "ZA2_CLIENT"
			elseif  aObraFiltro[a][1] == "ZH_LOJA"
				aObraFiltro[a][1] := "ZA2_LOJA"
				cNomeCampo := "ZA2_LOJA"
			elseif  aObraFiltro[a][1] == "A1_MUN"
				aObraFiltro[a][1] := "ZA2_MUNENT"
				cNomeCampo := "ZA2_MUNENT"
			elseif  aObraFiltro[a][1] == "A1_EST"
				aObraFiltro[a][1] := "ZA2_ESTENT"
				cNomeCampo := "ZA2_ESTENT"
			elseif  aObraFiltro[a][1] == "ZI_PRODUTO"
				aObraFiltro[a][1] := "ZA2_PRODUT"
				cNomeCampo := "ZA2_PRODUT"
			elseif  aObraFiltro[a][1] == "A1_VEND"
				aObraFiltro[a][1] := "ZA2_VEND"
				cNomeCampo := "ZA2_VEND"
			elseif  aObraFiltro[a][1] == "A1_FILIAL"
				aObraFiltro[a][1] := "ZA2_FILIAL"
				cNomeCampo := "ZA2_FILIAL"
			endif
			//

			do case
				case empty(aObraFiltro[a][2]) .and. !empty(aObraFiltro[a][3])
				cSQL_Obra  += " AND "+aObraFiltro[a][1]+" <= '"+aObraFiltro[a][3]+"' "

				case empty(aObraFiltro[a][3]) .and. !empty(aObraFiltro[a][2])
				cSQL_Obra += " AND "+aObraFiltro[a][1]+" >= '"+aObraFiltro[a][2]+"' "

				case !empty(aObraFiltro[a][2]) .and. !empty(aObraFiltro[a][3])
				cSQL_Obra += " AND "+aObraFiltro[a][1]+" BETWEEN '"+aObraFiltro[a][2]+"' AND '"+aObraFiltro[a][3]+"' "

			endcase
		next
		if	!empty(cSQL_Obra)
			_cQ_Obra := " SELECT DISTINCT ZA2_CLIENT, ZA2_LOJA, ZA2_NOMCLI, ZA2_NOME, ZA2_MUNENT, ZA2_ESTENT  FROM "+ RetSqlName("ZA2") + " Z	"
			_cQ_Obra += " INNER JOIN "+RetSqlName("SA1")+" SA1 ON A1_COD = ZA2_CLIENT AND A1_LOJA = ZA2_LOJA AND SA1.D_E_L_E_T_ = '' "
			_cQ_Obra += " WHERE Z.D_E_L_E_T_ = '' AND (Z.ZA2_LIBER = 'L' OR Z.ZA2_LIBER = ' ') AND Z.ZA2_FILIAL = '"+xFilial("ZA2")+"' " //Rodrigo - 07/02/17 - Mostrar apenas da filial corrente
			_cQ_Obra += cSQL_Obra   // Filtros escolhido pelo usuario -
			_cQ_Obra += " ORDER BY ZA2_CLIENT, ZA2_LOJA, ZA2_NOMCLI "

			TCQUERY _cQ_Obra NEW ALIAS "ZZ2"

			TCSETFIELD("ZZ2","ZI_DTBLOQ","D")

			ZZ2->(dbGotop())

			While ZZ2->(!EOF())
				AAdd(aDados,{ZZ2->ZA2_CLIENT,ZZ2->ZA2_LOJA,"OBRA:  " + ZZ2->ZA2_NOME + "     Cliente:  " +  ZZ2->ZA2_NOMCLI + "      Local:  " + alltrim(ZZ2->ZA2_MUNENT) +"-"+alltrim(ZZ2->ZA2_ESTENT)})
				ZZ2->(DbSkip())
			end
			ZZ2->(DbCloseArea())
		endif
	endif  //fim procura obra

	oBrw:SetArray(aDados)
	oBrw2:SetArray(aItens)
	oBrw:Refresh()
	oBrw2:Refresh()

return

/*/{Protheus.doc} mudouTipo

Efetua a alteração da mascara do TGET para obter valores percentuais ou decimais.

@author Rodrigo feitosa
@since 11/10/2013
@version P11

/*/
Static function mudouTipo()
	Local cCol    := ""
	Local cMasc   := ""
	Local aVars 	:= {"oGetCif","oGetCifD","oGetFob","oGetUni","oGetGer"}
	Local aVars2	:= {"nCif","nCifD","nFob","nUni","nGer"}
	Local aCoords	:= {"aPosObj4","aPosObj4","aPosObj4","aPosObj5","aPosObj5"}

	do case
		case nTipo == 1
		cMasc := '@E 999,999.99'
		oRad2:Enable()

		case nTipo == 2
		cMasc := '@E 999.99%'
		oRad2:Enable()

		case nTipo == 3
		cMasc := '@E 999,999.99'
		oRad2:Disable()

	endcase

	for i:=1 to Len(aVars)
		&(aVars2[i]) := 0

		//Juailson-Semar - Ajustar posicao por conta do novo campo Cif Descarga = 23/01/15
		//Local aVars 	:= {"oGetCif","oGetCifD","oGetFob","oGetUni","oGetGer"}
		if i == 2
			cCol := "-26"
		elseif i == 3
			cCol :=  "+135"
		elseif i == 4
			cCol := "-93"  //alltrim(cMunDe)
		elseif i == 5
			cCol := "+67"
		else
			cCol := "+0"
		endif

		//	   cCol := "+0"
		//
		nPos 	:= if(i%2==0,2,1)
		cBloc	:= "{|u| If(PCount() > 0, "+aVars2[i]+" := u, "+aVars2[i]+") }"
		&(aVars[i]) := TGet():New(&(aCoords[i])[nPos,1]+8,&(aCoords[i])[nPos,2]+&cCol,&cBloc;
		,oDlg,50,8,cMasc,,,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cValtoChar(&(aVars2[i])),,,,)
		&(aVars[i]):Refresh()
	next

	oDlg:CtrlRefresh()

return

/*/{Protheus.doc} calcObjetos

Efetua o calculo da area dos objetos de acordo com a resolução.

@author Rodrigo feitosa
@since 11/10/2013
@version P11

/*/
Static function calcObjetos()

	Local aObjects 		:= {},aObjects2		:= {},aObjects3		:= {}
	Local aObjects4		:= {},aObjects5		:= {},aObjects6		:= {}
	Local aObjects7		:= {},aObjects8		:= {},aObjects9		:= {}
	Local aObjects10	:= {},aObjects11	:= {},aObjects12	:= {}
	Local aObjects13	:= {},aObjects14	:= {},aObjects15	:= {}
	Local aObjects16	:= {},aObjects17	:= {},aObjects18	:= {}
	//////////////////////////////////////////////////////////////////////////
	//Posicionamento dos objetos na tela                                    //
	//dividindo a tela em 2 parte, 30% da tela a esquerda para parametros   //
	//70% da tela a direita para browser                                    //
	//////////////////////////////////////////////////////////////////////////
	aTam := MsAdvSize(.F.)

	AAdd(aObjects,{30,100,.T.,.T.})
	AAdd(aObjects,{70,100,.T.,.T.})

	aInfo := { aTam[1],aTam[2],aTam[3],aTam[4],3,3 }

	aPosObj := MsObjSize(aInfo,aObjects,.T.,.T.)
	///////////////////////////////////////////////////////////////////////////
	//Posicionamento dos objetos na tela                                     //
	//dividindo a parte da esquerda em 2 partes 1 acima da outra para exibir //
	//os filtros na parte de cima e os valores do reajuste na de baixo       //
	///////////////////////////////////////////////////////////////////////////
	AAdd(aObjects2,{80,175,.T.,.T.})
	AAdd(aObjects2,{80,075,.T.,.T.})
	aInfo2 := { aPosObj[1,1],aPosObj[1,2],aPosObj[1,4],aPosObj[1,3],1,1}

	aPosObj2 := MsObjSize(aInfo2,aObjects2,.T.,.F.)
	///////////////////////////////////////////////////////////////////////////
	//Posicionamento dos objetos na tela                                     //
	//dividindo a parte da esquerda de baixo em 4 partes, que representam    //
	//o tipo de reajuste, valores e botão                                    //
	///////////////////////////////////////////////////////////////////////////
	AAdd(aObjects3,{100,180,.T.,.T.})
	AAdd(aObjects3,{100,100,.T.,.T.})
	AAdd(aObjects3,{100,100,.T.,.T.})
//	AAdd(aObjects3,{100,80,.T.,.T.})
//	AAdd(aObjects3,{100,100,.T.,.T.})
	aInfo3 := { aPosObj2[2,2],aPosObj2[2,1],aPosObj2[2,4],aPosObj2[2,3],5,5}

	aPosObj3 := MsObjSize(aInfo3,aObjects3,.T.,.F.)
	///////////////////////////////////////////////////////////////////////////
	//Posicionamento dos objetos na tela                                     //
	//dividindo a segunda linha do grupo da esquerda baixo da tela           //
	//que conterá os valores para cif e fob                                  //
	///////////////////////////////////////////////////////////////////////////
	AAdd(aObjects4,{100,100,.T.,.T.})
	AAdd(aObjects4,{100,100,.T.,.T.})
	aInfo4 := { aPosObj3[2,2],aPosObj3[2,1],aPosObj3[2,4],aPosObj3[2,3],1,1}

	aPosObj4 := MsObjSize(aInfo4,aObjects4,.T.,.T.)
	///////////////////////////////////////////////////////////////////////////
	//Posicionamento dos objetos na tela                                     //
	//dividindo a terceira linha do grupo da esquerda baixo da tela          //
	//que conterá os valores para unitario e gerencial                       //
	///////////////////////////////////////////////////////////////////////////
	AAdd(aObjects5,{100,100,.T.,.T.})
	AAdd(aObjects5,{100,100,.T.,.T.})
	aInfo5 := { aPosObj3[3,2],aPosObj3[3,1],aPosObj3[3,4],aPosObj3[3,3],1,1}

	aPosObj5 := MsObjSize(aInfo5,aObjects5,.T.,.T.)
	///////////////////////////////////////////////////////////////////////////
	//Posicionamento dos objetos na tela                                     //
	//dividindo a quarta linha do grupo da esquerda baixo da tela 	          //
	//que conterá o botão para confirmar o reajuste                          //
	///////////////////////////////////////////////////////////////////////////
//	AAdd(aObjects6,{100,100,.T.,.T.})
//	aInfo6 := { aPosObj3[4,2],aPosObj3[4,1],aPosObj3[4,4],aPosObj3[4,3],1,1}

//	aPosObj6 := MsObjSize(aInfo6,aObjects6,.T.,.F.)
	///////////////////////////////////////////////////////////////////////////
	//Posicionamento dos objetos na tela                                     //
	//dividindo a parte da esquerda de cima em 7 partes, que representam     //
	//os valores para filtro                                                 //
	///////////////////////////////////////////////////////////////////////////
	AAdd(aObjects7,{100,100,.T.,.T.})
	AAdd(aObjects7,{100,100,.T.,.T.})
	AAdd(aObjects7,{100,100,.T.,.T.})
	AAdd(aObjects7,{100,100,.T.,.T.})
	AAdd(aObjects7,{100,100,.T.,.T.})
	AAdd(aObjects7,{100,100,.T.,.T.})
	AAdd(aObjects7,{100,100,.T.,.T.}) //Grupo de Preço
	AAdd(aObjects7,{100,100,.T.,.T.}) //Meso Região
	AAdd(aObjects7,{100,100,.T.,.T.}) //Meso Região
	aInfo7 := { aPosObj2[1,2],aPosObj2[1,1],aPosObj2[1,4],aPosObj2[1,3],5,5}

	aPosObj7 := MsObjSize(aInfo7,aObjects7,.T.,.F.)
	///////////////////////////////////////////////////////////////////////////
	//Posicionamento dos objetos na tela                                     //
	//dividindo a primeira linha do grupo da esquerda cima da tela           //
	//que conterá os valores: filial(de),cliente(de),loja(de)                //
	///////////////////////////////////////////////////////////////////////////
	AAdd(aObjects8,{100,100,.T.,.T.})
	AAdd(aObjects8,{200,100,.T.,.T.})
	AAdd(aObjects8,{100,100,.T.,.T.})
	aInfo8 := { aPosObj7[1,2],aPosObj7[1,1],aPosObj7[1,4],aPosObj7[1,3],5,1 }

	aPosObj8 := MsObjSize(aInfo8,aObjects8,.T.,.T.)
	///////////////////////////////////////////////////////////////////////////
	//Posicionamento dos objetos na tela                                     //
	//dividindo a segunda linha do grupo da esquerda cima da tela             //
	//que conterá os valores: filial(ate),cliente(ate),loja(ate)             //
	///////////////////////////////////////////////////////////////////////////
	AAdd(aObjects9,{100,100,.T.,.T.})
	AAdd(aObjects9,{200,100,.T.,.T.})
	AAdd(aObjects9,{100,100,.T.,.T.})
	aInfo9 := { aPosObj7[2,2],aPosObj7[2,1],aPosObj7[2,4],aPosObj7[2,3],5,1 }

	aPosObj9 := MsObjSize(aInfo9,aObjects9,.T.,.T.)
	///////////////////////////////////////////////////////////////////////////
	//Posicionamento dos objetos na tela                                     //
	//dividindo a terceira linha do grupo da esquerda cima da tela           //
	//que conterá os valores: municipio(de) e estado(de)                     //
	///////////////////////////////////////////////////////////////////////////
	AAdd(aObjects10,{300,100,.T.,.T.})
	AAdd(aObjects10,{100,100,.T.,.T.})
	aInfo10 := { aPosObj7[3,2],aPosObj7[3,1],aPosObj7[3,4],aPosObj7[3,3],5,1 }

	aPosObj10 := MsObjSize(aInfo10,aObjects10,.T.,.T.)
	///////////////////////////////////////////////////////////////////////////
	//Posicionamento dos objetos na tela                                     //
	//dividindo a quarta linha do grupo da esquerda cima da tela             //
	//que conterá os valores: municipio(ate) e estado(ate)                   //
	///////////////////////////////////////////////////////////////////////////
	AAdd(aObjects11,{300,100,.T.,.T.})
	AAdd(aObjects11,{100,100,.T.,.T.})
	aInfo11 := { aPosObj7[4,2],aPosObj7[4,1],aPosObj7[4,4],aPosObj7[4,3],5,1 }

	aPosObj11 := MsObjSize(aInfo11,aObjects11,.T.,.T.)
	///////////////////////////////////////////////////////////////////////////
	//Posicionamento dos objetos na tela                                     //
	//dividindo a quinta linha do grupo da esquerda cima da tela             //
	//que conterá os valores: produto(de) e produto(ate)                     //
	///////////////////////////////////////////////////////////////////////////
	AAdd(aObjects12,{100,100,.T.,.T.})
	AAdd(aObjects12,{100,100,.T.,.T.})
	aInfo12 := { aPosObj7[5,2],aPosObj7[5,1],aPosObj7[5,4],aPosObj7[5,3],5,1 }

	aPosObj12 := MsObjSize(aInfo12,aObjects12,.T.,.T.)
	///////////////////////////////////////////////////////////////////////////
	//Posicionamento dos objetos na tela                                     //
	//dividindo a sexta linha do grupo da esquerda cima da tela              //
	//que conterá os valores: vendedor(de) e vendedor(ate)                   //
	///////////////////////////////////////////////////////////////////////////
	AAdd(aObjects15,{100,100,.T.,.T.})
	AAdd(aObjects15,{100,100,.T.,.T.})
	aInfo15 := { aPosObj7[6,2],aPosObj7[6,1],aPosObj7[6,4],aPosObj7[6,3],5,1 }

	aPosObj15 := MsObjSize(aInfo15,aObjects15,.T.,.T.)


	///////////////////////////////////////////////////////////////////////////
	//Posicionamento dos objetos na tela                                     //
	//dividindo a sexta linha do grupo da esquerda cima da tela              //
	//que conterá os valores: Grupo Preço (de) e Grupo Preço (Ate)           //
	///////////////////////////////////////////////////////////////////////////
	AAdd(aObjects16,{100,100,.T.,.T.})
	AAdd(aObjects16,{100,100,.T.,.T.})
	aInfo16 := { aPosObj7[7,2],aPosObj7[7,1],aPosObj7[7,4],aPosObj7[7,3],5,1 }

	aPosObj16 := MsObjSize(aInfo16,aObjects16,.T.,.T.)

	///////////////////////////////////////////////////////////////////////////
	//Posicionamento dos objetos na tela                                     //
	//dividindo a sexta linha do grupo da esquerda cima da tela              //
	//que conterá os valores: Meso região (de) e Meso Região (Ate)           //
	///////////////////////////////////////////////////////////////////////////
	AAdd(aObjects17,{100,100,.T.,.T.})
	AAdd(aObjects17,{100,100,.T.,.T.})
	aInfo17 := { aPosObj7[8,2],aPosObj7[8,1],aPosObj7[8,4],aPosObj7[8,3],5,1 }

	aPosObj17 := MsObjSize(aInfo17,aObjects17,.T.,.T.)

	///////////////////////////////////////////////////////////////////////////
	//Posicionamento dos objetos na tela                                     //
	//dividindo a sexta linha do grupo da esquerda cima da tela              //
	//que conterá os valores: Meso região (de) e Meso Região (Ate)           //
	///////////////////////////////////////////////////////////////////////////
	AAdd(aObjects18,{100,100,.T.,.T.})
	AAdd(aObjects18,{100,100,.T.,.T.})
	aInfo18 := { aPosObj7[9,2],aPosObj7[9,1],aPosObj7[9,4],aPosObj7[9,3],5,1 }

	aPosObj18 := MsObjSize(aInfo18,aObjects18,.T.,.T.)


	//////////////////////////////////////////////////////////////////////////
	//Posicionamento dos objetos na tela                                    //
	//dividindo a parte direta da janela em 2 parte cada uma com 50% de     //
	//altura, contendo os grupos que vão conter os browsers                 //
	//////////////////////////////////////////////////////////////////////////
	AAdd(aObjects13,{100,200,.T.,.T.})
	AAdd(aObjects13,{100,100,.T.,.T.})
	aInfo13 := { aPosObj[2,2],aPosObj[2,1],aPosObj[2,4],aPosObj[2,3],1,1 }

	aPosObj13 := MsObjSize(aInfo13,aObjects13,.T.,.F.)
	///////////////////////////////////////////////////////////////////////////
	//Posicionamento dos objetos na tela                                     //
	//dividindo a primeira linha do grupo da esquerda baixo da tela          //
	//que conterá os tipos de reajuste e se o mesmo será acrescimo           //
	///////////////////////////////////////////////////////////////////////////
	AAdd(aObjects14,{100,100,.T.,.T.})
	AAdd(aObjects14,{100,100,.T.,.T.})
	aInfo14 := { aPosObj3[1,2],aPosObj3[1,1],aPosObj3[1,4],aPosObj3[1,3],5,5}

	aPosObj14 := MsObjSize(aInfo14,aObjects14,.T.,.T.)

return

/*/{Protheus.doc} buscaItens

Efetua a busca e armazenamento dos itens da tabela de preço que ativar a função.

@author Rodrigo feitosa
@since 11/10/2013
@version P11

/*/
Static function buscaItens()

	Local nPos		:= oBrw:nAt
	Local cAdd		:= "{"
	aItens := {}

	If substr(aDados[nPos][3], 1, 4) == "OBRA" .And. cEmpAnt + cFilAnt $ '0210|3001|0211|0214'
		cSQL := "SELECT * FROM "+RetSqlName("ZA2")+" ZA2 "
		cSQL += "WHERE ZA2.D_E_L_E_T_ = '' AND ZA2_CLIENT = '"+aDados[nPos][1]+"' AND "
		cSQL += "ZA2_NOME = '"+ substr(aDados[nPos][3], 8, TAMSX3("ZA2_NOME")[1])+ "' AND "

		cSQL += "ZA2_LOJA = '"+aDados[nPos][2]+"' "
		cSQL += "AND ZA2_FILIAL = '"+xFilial("ZA2")+"' " //Rodrigo - 07/02/17 - Mostrar apenas da filial corrente

		do case
			case !Empty(cProdDe) .and. !Empty(cProdAte)
			cSQL += " AND ZA2_PRODUT BETWEEN '"+cProdDe+"' AND '"+cProdAte+"' "
			case !Empty(cProdDe) .and. Empty(cProdAte)
			cSQL += " AND ZA2_PRODUT >= '"+cProdDe+"' "
			case Empty(cProdDe) .and. !Empty(cProdAte)
			cSQL += " AND ZA2_PRODUT <= '"+cProdAte+"' "

		endcase

		cSQL += " ORDER BY  ZA2_DTVIG, ZA2_LIBER "

		TCQUERY cSQL New Alias (cTableQry)

		For i:=1 to Len(_aZA2Campos)
			if empty(_aZA2Campos[i])

				cAdd += " " + (if(i<>Len(_aZA2Campos),",","}"))

			elseif _aZA2Campos[i] == "ZA2_DTBLOQ"  .or.  _aZA2Campos[i] == "ZA2_DTVIG"

				cAdd += "DTOC(STOD((cTableQry)->"+ _aZA2Campos[i]  + "))" + (if(i<>Len(_aZA2Campos),",","}" ))
			else
				cAdd += "(cTableQry)->"+_aZA2Campos[i] + (if(i<>Len(_aZA2Campos),",","}"))
			endif
		next

		DbSelectArea(cTableQry)
		(cTableQry)->(DbGoTop())
		While (cTableQry)->(!EOF())
			AAdd(aItens,&cAdd)
			(cTableQry)->(DbSkip())
		end
		(cTableQry)->(DbCloseArea())

	else

		cSQL := "SELECT * FROM "+RetSqlName(cTableIt)+" SZI "
		cSQL += "WHERE SZI.D_E_L_E_T_ = '' AND ZI_CLIENTE = '"+aDados[nPos][1]+"' AND "
		cSQL += "ZI_LOJA = '"+aDados[nPos][2]+"' "
		cSQL += "AND ZI_FILIAL = '"+xFilial("SZI")+"' "

		do case
			case !Empty(cProdDe) .and. !Empty(cProdAte)
			cSQL += " AND ZI_PRODUTO BETWEEN '"+cProdDe+"' AND '"+cProdAte+"' "
			case !Empty(cProdDe) .and. Empty(cProdAte)
			cSQL += " AND ZI_PRODUTO >= '"+cProdDe+"' "
			case Empty(cProdDe) .and. !Empty(cProdAte)
			cSQL += " AND ZI_PRODUTO <= '"+cProdAte+"' "
		endcase

		cSQL += " ORDER BY  ZI_DTVIGEN,ZI_LIBER "

		TCQUERY cSQL New Alias (cTableQry)

		For i:=1 to Len(_aCampos)
			if _aCampos[i] == "ZI_DTBLOQ"  .or.  _aCampos[i] == "ZI_DTVIGEN"
				cAdd += "DTOC(STOD((cTableQry)->"+_aCampos[i]  + "))" + (if(i<>Len(_aCampos),",","}" ))
			else
				cAdd += "(cTableQry)->"+_aCampos[i] + (if(i<>Len(_aCampos),",","}"))
			endif
		next

		DbSelectArea(cTableQry)
		(cTableQry)->(DbGoTop())
		While (cTableQry)->(!EOF())
			AAdd(aItens,&cAdd)
			(cTableQry)->(DbSkip())
		end
		(cTableQry)->(DbCloseArea())
	endif

	oBrw2:SetArray(aItens)
	oBrw2:Refresh()

Return

/*/{Protheus.doc} buscaItens

Efetua a confirmação do reajuste e a chamada do metodo que irá realizar o reajuste.

@author Rodrigo feitosa
@since 11/10/2013
@version P11

alisalison	/*/
Static function reajustar()

	Private _cMsg01    := ''
	Private _lFim      := .F.
	Private _lAborta01 := .T.
	Private _bAcao01       := {|_lFim| MZ133_A(@_lFim) }
	Private _cTitulo01 := 'Processando...'
	Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

Return

Static function MZ133_A()

	Local cTitulo		:= "Confirmação de reajuste"
	Local cMsg
	Local aOp			:= {"Sim","Nao"}
	Local cSQL			:= " "
	Local lBloqueado    := .F.
	Private cRESP_ATUAL_OBRAS := "S"

	cMsg := "Tem certeza que deseja aplicar o reajuste do tipo "+aItensRad[nTipo]+" com os valores:"+CRLF
	cMsg += "CIF - ["+cValtoChar(nCif)+"]"+CRLF
	cMsg += "CIF Descarga - ["+cValtoChar(nCifD)+"]"+CRLF
	cMsg += "FOB - ["+cValtoChar(nFOB)+"]"+CRLF
	cMSG += "UNITARIO - ["+cValtoChar(nUni)+"]"+CRLF
	cMsg += "GERENCIAL - ["+cValtoChar(nGer)+"]"+CRLF
	cMsg += "Para "+cValtoChar(Len(aDados))+" tabelas de preço?"

	if Aviso(cTitulo,cMsg,aOp,3) == 2; return; endif;

	//IF	cempant $ '30'   //Juailson Semar - Pergunta se vai reajustar Preco, obra, ou ambos. 22/05/15		Comentado por Alison - 22/07/2016
	If cEmpAnt + cFilAnt $ '0101|0203|0210|0211|0214|0213|0218'		//Incluso a empresa 0218 - 18/04/18
		PergRest( cPerg2 ) // Criacao de perguntas dinamicas
		if !PERGUNTE(cPerg2,.T.)
			return
		endif
	ENDIF

	if  mv_par01 = 1 .or. mv_par01 = 3 // Respondeu alterar Preco ou ambos

		for a:=1 to Len(aFiltro)
			do case
				case empty(aFiltro[a][2]) .and. !empty(aFiltro[a][3])
				cSQL += " AND "+aFiltro[a][1]+" <= '"+aFiltro[a][3]+"' "

				case empty(aFiltro[a][3]) .and. !empty(aFiltro[a][2])
				cSQL += " AND "+aFiltro[a][1]+" >= '"+aFiltro[a][2]+"' "

				case !empty(aFiltro[a][2]) .and. !empty(aFiltro[a][3])
				cSQL += " AND UPPER("+aFiltro[a][1]+") BETWEEN '"+aFiltro[a][2]+"' AND '"+aFiltro[a][3]+"' "

			endcase
		next

		_cQ:= " DELETE "+RetSqlName("SZI")+" FROM "+RetSqlName("SZI")+" A INNER JOIN "+RetSqlName("SA1")+" B ON ZI_CLIENTE = A1_COD AND ZI_LOJA = A1_LOJA "
		_cQ+= " INNER JOIN "+RetSqlName("SZH")+" C ON ZI_FILIAL = ZH_FILIAL AND ZI_CLIENTE = ZH_CLIENTE AND ZI_LOJA = ZH_LOJA "
		_cQ+= " WHERE A.D_E_L_E_T_ = '' AND ZI_LIBER = '' AND B.D_E_L_E_T_ = '' AND C.D_E_L_E_T_ = '' "
		_cQ+= " AND ZI_FILIAL = '"+xFilial("SZI")+"' "
		_cQ+= cSQL

		TCSQLEXEC(_cQ)

		_cQ:= " DELETE "+RetSqlName("SCR")+" FROM "+RetSqlName("SCR")+"  A INNER JOIN "+RetSqlName("SA1")+" B ON CR_YCLIENT=A1_COD AND CR_YLOJA=A1_LOJA "
		_cQ+= " INNER JOIN "+RetSqlName("SZH")+" C ON CR_FILIAL = ZH_FILIAL AND CR_YCLIENT = ZH_CLIENTE AND CR_YLOJA = ZH_LOJA "
		_cQ+= " WHERE A.D_E_L_E_T_ = '' AND B.D_E_L_E_T_ = '' AND C.D_E_L_E_T_ = '' AND CR_TIPO = '02' AND CR_DATALIB = '' "
		_cQ+= " AND CR_FILIAL = '"+xFilial("SCR")+"' "
		_cQ+= cSQL

		TCSQLEXEC(_cQ)

		_cQ:= " DELETE "+RetSqlName("ZAH")+" FROM "+RetSqlName("ZAH")+"  A INNER JOIN "+RetSqlName("SA1")+" B ON ZAH_YCLIEN=A1_COD AND ZAH_YLOJA=A1_LOJA "
		_cQ+= " INNER JOIN "+RetSqlName("SZH")+" C ON ZAH_FILIAL = ZH_FILIAL AND ZAH_YCLIEN = ZH_CLIENTE AND ZAH_YLOJA = ZH_LOJA "
		_cQ+= " WHERE A.D_E_L_E_T_ = '' AND B.D_E_L_E_T_ = '' AND C.D_E_L_E_T_ = '' AND ZAH_TIPO = '02' AND ZAH_DATALI = '' "
		_cQ+= " AND ZAH_FILIAL = '"+xFilial("ZAH")+"' "
		_cQ+= cSQL

		TCSQLEXEC(_cQ)

		_cQ:= " SELECT * FROM "+RetSqlName("SZI")+" A INNER JOIN "+RetSqlName("SA1")+" B ON ZI_CLIENTE=A1_COD AND ZI_LOJA=A1_LOJA "
		_cQ+= " INNER JOIN "+RetSqlName("SZH")+" C ON ZI_FILIAL = ZH_FILIAL AND ZI_CLIENTE = ZH_CLIENTE AND ZI_LOJA = ZH_LOJA "
		_cQ+= " AND ZI_LIBER <> 'B' AND ZI_FILIAL = '"+xFilial("SZI")+"' "  // INCLUIDO POR ALEXANDRO 10/07/17
		_cQ+= " AND A.D_E_L_E_T_ = '' AND B.D_E_L_E_T_ = '' AND C.D_E_L_E_T_ = '' "// INCLUIDO POR ALEXANDRO 10/07/17

		_cQ+= cSQL   // Filtros escolhido pelo usuario -

		_cQ+= " ORDER BY ZI_CLIENTE,ZI_LOJA,ZI_PRODUTO "

		TCQUERY _cQ NEW ALIAS "ZZ"

		TCSETFIELD("ZZ","ZI_DTBLOQ","D")

		ZZ->(dbGotop())

		ProcRegua(ZZ->(U_CONTREG()))

		While ZZ->(!Eof())

			IncProc("Processando!!")

			aRet       := MIZ826E()
			lBloqueado := aRet[2]
			//MIZ826D(aRet[1],aRet[2])
			MIZ826D(aRet[1],.F.)

			ZZ->(DbSkip())
		end

		ZZ->(DbCloseArea())
	endif

	If cEmpAnt + cFilAnt $ '0210|3001|0211|0214' .And. (mv_par01 = 2 .or. mv_par01 = 3)
		AjustarPrecoObra(aFiltro)
	endif

	If 	lBloqueado
		MSGINFO("PRECO TABELA BLOQUEADO, FAVOR SOLICITAR LIBERACAO!!!")
	Else
		msginfo('Reajuste aplicado com sucesso!')
	Endif

Return

Static function MIZ826D(nRecno,lBloq)

	local cResposta := ""
	Local wArea := getArea()

	if !lBloq
		DbSelectArea("SZI")
		DbSetOrder(1)
		DbGoTo(nRecno)
		while MsSeek(xFilial("SZI")+SZI->ZI_CLIENTE+SZI->ZI_LOJA+SZI->ZI_PRODUTO+"L")
			SZI->(RecLock("SZI",.F.))
			SZI->ZI_LIBER := "B"
			SZI->ZI_DTBLOQ := Date()
			SZI->(MsUnLock())
		EndDo

		DbGoTo(nRecno)
		SZI->(RecLock("SZI",.F.))
		SZI->ZI_LIBER  := "L"
		SZI->ZI_DTVIGEN:= Date()
		SZI->ZI_USRLIB := Substr(cUsuario,7,15)
		SZI->(MsUnLock())

	Endif

	restArea(wArea)

return


Static Function MIZ826E()  // Calcula o novo preco --- LER A TEMPORARIA ZZ

	Local _cGrAprov	:= GETMV("MZ_GRAPROV")

	SZI->(RecLock("SZI",.T.))
	SZI->ZI_FILIAL  := ZZ->ZI_FILIAL
	SZI->ZI_CLIENTE := ZZ->ZI_CLIENTE
	SZI->ZI_LOJA    := ZZ->ZI_LOJA
	SZI->ZI_PRODUTO := ZZ->ZI_PRODUTO
	SZI->ZI_DESC    := ZZ->ZI_DESC
	//------------------------------------------------------------------------------------------------------//
	//			Guarda o preço da ultima tabela de preço não bloqueada e data do ajuste em lote				//
	//									Marcus Vinicius - 18/09/2017										//
	//------------------------------------------------------------------------------------------------------//
	SZI->ZI_DTRJLOT		:= dDataBase
	SZI->ZI_PCIFANT		:= ZZ->ZI_PRECO
	SZI->ZI_PCIFDAN		:= ZZ->ZI_PRECOD
	SZI->ZI_PFOBANT		:= ZZ->ZI_PRECOF
	SZI->ZI_PGERANT		:= ZZ->ZI_PGER
	SZI->ZI_PUNITAN		:= ZZ->ZI_PRCUNIT
	//------------------------------------------------------------------------------------------------------//

	do case
		case nTipo == 1	//VALOR
		if nAcres == 1
			SZI->ZI_PRECO	:= ZZ->ZI_PRECO	+ nCIF
			SZI->ZI_PRECOD	:= ZZ->ZI_PRECOD + nCIFD //Juailson-Semar - Preco Cif Descarga - 23/01/15
			SZI->ZI_PRECOF 	:= ZZ->ZI_PRECOF	+ nFOB
			SZI->ZI_PGER	:= ZZ->ZI_PGER	+ nGER
			SZI->ZI_PRCUNIT	:= ZZ->ZI_PRCUNIT	+ nUNI
		else
			SZI->ZI_PRECO	:= ZZ->ZI_PRECO	- nCIF
			SZI->ZI_PRECOD	:= ZZ->ZI_PRECOD - nCIFD //Juailson-Semar - Preco Cif Descarga - 23/01/15
			SZI->ZI_PRECOF	:= ZZ->ZI_PRECOF	- nFOB
			SZI->ZI_PGER	:= ZZ->ZI_PGER	- nGER
			SZI->ZI_PRCUNIT	:= ZZ->ZI_PRCUNIT	- nUNI
		endif

		case nTipo == 2	//PERCENTUAL
		if nAcres == 1
			SZI->ZI_PRECO	:= ZZ->ZI_PRECO	+ (ZZ->ZI_PRECO	* (nCIF/100) )
			SZI->ZI_PRECOD	:= ZZ->ZI_PRECOD	+ (ZZ->ZI_PRECOD * (nCIFD/100) ) //Juailson-Semar - Preco Cif Descarga - 23/01/15
			SZI->ZI_PRECOF	:= ZZ->ZI_PRECOF	+ (ZZ->ZI_PRECOF	* (nFOB/100) )
			SZI->ZI_PGER	:= ZZ->ZI_PGER	+ (ZZ->ZI_PGER	* (nGER/100) )
			SZI->ZI_PRCUNIT	:= ZZ->ZI_PRCUNIT	+ (ZZ->ZI_PRCUNIT	* (nUNI/100) )
		else
			SZI->ZI_PRECO	:= ZZ->ZI_PRECO	- (ZZ->ZI_PRECO	* (nCIF/100) )
			SZI->ZI_PRECOD	:= ZZ->ZI_PRECOD - (ZZ->ZI_PRECOD	* (nCIFD/100) ) //Juailson-Semar - Preco Cif Descarga - 23/01/15
			SZI->ZI_PRECOF	:= ZZ->ZI_PRECOF	- (ZZ->ZI_PRECOF	* (nFOB/100) )
			SZI->ZI_PGER	:= ZZ->ZI_PGER	- (ZZ->ZI_PGER	* (nGER/100) )
			SZI->ZI_PRCUNIT	:= ZZ->ZI_PRCUNIT	- (ZZ->ZI_PRCUNIT	* (nUNI/100) )
		endif

		case nTipo == 3	//ALINHAMENTO
		SZI->ZI_PRECO  	:= nCIF
		SZI->ZI_PRECOD 	:= nCIFD //Juailson-Semar - Preco Cif Descarga - 23/01/15
		SZI->ZI_PRECOF	:= nFOB
		SZI->ZI_PGER	:= nGER
		SZI->ZI_PRCUNIT	:= nUNI
	endcase
	SZI->ZI_DESCON  := ZZ->ZI_DESCON
	SZI->ZI_DESCONF := ZZ->ZI_DESCONF
	SZI->ZI_DTVIGEN := Date()
	SZI->ZI_USRINC  := cUsername
	SZI->(MsUnLock())

	SA1->(dbSetOrder(1))
	SA1->(msSeek(xFilial("SA1")+ SZI->ZI_CLIENTE + SZI->ZI_LOJA))

	SB1->(dbSetOrder(1))
	SB1->(msSeek(xFilial("SB1")+ SZI->ZI_PRODUTO))

	_cProduto := SZI->ZI_PRODUTO
	_lEncont  := .F.

	If !Alltrim(SB1->B1_TIPCAR) $ "CDC"

		ZA4->(dbSetOrder(2))
		If ZA4->(!msSeek(xFilial("ZA4")+SA1->A1_EST  + SB1->B1_COD + SA1->A1_ATIVIDA + SA1->A1_MUN))
			If ZA4->(!msSeek(xFilial("ZA4")+SA1->A1_EST  + SB1->B1_COD + SA1->A1_ATIVIDA ))
				If ZA4->(msSeek(xFilial("ZA4")+SA1->A1_EST  + SB1->B1_COD ))
					_lEncont :=.T.
				Endif
			Endif
		Else
			_lEncont :=.T.
		Endif

		_lVerPrCif := .F.
		_lVerPrFob := .F.
		_lVerPrCiD := .F.

		If SZI->ZI_PRECO < ZA4->ZA4_VLMCIF .And. SZI->ZI_PRECO > 0
			_lVerPrCif := .T.
		Endif

		If SZI->ZI_PRECOD < ZA4->ZA4_VLMCID .And. SZI->ZI_PRECOD > 0
			_lVerPrCiD := .T.
		Endif

		If SZI->ZI_PRECOF < ZA4->ZA4_VLMFOB .And. SZI->ZI_PRECOF > 0
			_lVerPrFob := .T.
		Endif

		If _lVerPrCif .Or. _lVerPrFob .Or. _lVerPrCiD
			_cQ := " SELECT MAX(CR_NUM) AS CR_NUM FROM "+RetSqlName("SCR")+" WHERE D_E_L_E_T_ = '' "
			_cQ += " AND CR_FILIAL = '"+xFilial("SCR")+"' AND CR_TIPO = '02' "

			TCQUERY _cQ NEW ALIAS "ZZ2"

			If Empty(ZZ2->CR_NUM)
				_cNum := "000001"
			Else
				_cNum := GETSXENUM("SCR","CR_NUM")
				ConfirmSX8()
			Endif

			ZZ2->(dbCloseArea())

			lFirstNiv   := .T.
			cAuxNivel   := ""
			_lLibera    := .T.

			SAL->(dbSetOrder(2))
			If SAL->(msSeek(xFilial()+_cGrAprov))

				While SAL->(!Eof()) .And. xFilial("SAL")+_cGrAprov == SAL->AL_FILIAL+SAL->AL_COD

					If lFirstNiv
						cAuxNivel := SAL->AL_NIVEL
						lFirstNiv := .F.
					EndIf

					SCR->(Reclock("SCR",.T.))
					SCR->CR_FILIAL	:= xFilial("SCR")
					SCR->CR_NUM		:= _cNum
					SCR->CR_TIPO	:= "02"
					SCR->CR_NIVEL	:= SAL->AL_NIVEL
					SCR->CR_USER	:= SAL->AL_USER
					SCR->CR_APROV	:= SAL->AL_APROV
					SCR->CR_STATUS	:= "02"
					SCR->CR_EMISSAO := dDataBase
					SCR->CR_MOEDA	:= 1
					SCR->CR_TXMOEDA := 1
					SCR->CR_OBS     := Alltrim(SM0->M0_NOME) + " - TABELA DE PRECO VENDAS"

					If _lVerPrCif
						If SZI->ZI_PRECO < ZA4->ZA4_VLMCIF .Or. !_lEncont
							SCR->CR_YREFCIF := ZA4->ZA4_VLMCIF
							SCR->CR_YPRCCIF := SZI->ZI_PRECO
							SCR->CR_TOTAL	:= SZI->ZI_PRECO
						Endif
					Endif

					If _lVerPrCiD
						If SZI->ZI_PRECOD < ZA4->ZA4_VLMCID .Or. !_lEncont
							SCR->CR_YREFCID := ZA4->ZA4_VLMCID
							SCR->CR_YPRCCID := SZI->ZI_PRECOD
							SCR->CR_TOTAL	:= SZI->ZI_PRECOD
						Endif
					Endif

					If _lVerPrFob
						If SZI->ZI_PRECOF < ZA4->ZA4_VLMFOB .Or. !_lEncont
							SCR->CR_YREFFOB := ZA4->ZA4_VLMFOB
							SCR->CR_YPRCFOB := SZI->ZI_PRECOF
							SCR->CR_TOTAL	:= SZI->ZI_PRECOF
						Endif
					Endif

					If SZI->ZI_PGER   < ZA4->ZA4_VLMGER
						SCR->CR_YREFFOB := ZA4->ZA4_VLMGER
						SCR->CR_YPRCFOB := SZI->ZI_PGER
						SCR->CR_TOTAL	:= SZI->ZI_PGER
					Endif

					SCR->CR_YCLIENT := SZI->ZI_CLIENTE
					SCR->CR_YLOJA   := SZI->ZI_LOJA
					SCR->CR_YPRODUT := SZI->ZI_PRODUTO
					SCR->(MsUnlock())

					ZAH->(RecLock("ZAH",.T.))
					ZAH->ZAH_FILIAL:= SCR->CR_FILIAL
					ZAH->ZAH_NUM   := SCR->CR_NUM
					ZAH->ZAH_TIPO  := SCR->CR_TIPO
					ZAH->ZAH_NIVEL := SCR->CR_NIVEL
					ZAH->ZAH_USER  := SCR->CR_USER
					ZAH->ZAH_APROV := SCR->CR_APROV
					ZAH->ZAH_STATUS:= SCR->CR_STATUS
					ZAH->ZAH_TOTAL := SCR->CR_TOTAL
					ZAH->ZAH_EMISSA:= SCR->CR_EMISSAO
					ZAH->ZAH_MOEDA := SCR->CR_MOEDA
					ZAH->ZAH_TXMOED:= SCR->CR_TXMOEDA
					ZAH->ZAH_OBS   := SCR->CR_OBS
					ZAH->ZAH_YREFCI:= SCR->CR_YREFCIF
					ZAH->ZAH_YPRCCI:= SCR->CR_YPRCCIF
					ZAH->ZAH_TOTAL := SCR->CR_TOTAL
					ZAH->ZAH_YREFFO:= SCR->CR_YREFFOB
					ZAH->ZAH_YPRCFO:= SCR->CR_YPRCFOB
					ZAH->ZAH_YREFGE:= SCR->CR_YREFGER
					ZAH->ZAH_YPRCGE:= SCR->CR_YPRCGER
					ZAH->ZAH_YCLIEN:= SCR->CR_YCLIENT
					ZAH->ZAH_YLOJA := SCR->CR_YLOJA
					ZAH->ZAH_YPRODU:= SCR->CR_YPRODUT
					ZAH->ZAH_YOBRA := SCR->CR_YOBRA
					ZAH->ZAH_YCODTA:= SCR->CR_YCODTAB
					ZAH->ZAH_YFORNE:= SCR->CR_YFORNEC
					ZAH->ZAH_YLOJFO:= SCR->CR_YLOJFOR
					ZAH->(MsUnlock())

					SAL->(dbSkip())
				EndDo
			EndIf
		Endif
	Endif

Return {SZI->(Recno()),if(!Alltrim(SB1->B1_TIPCAR) $ "CDC",_lVerPrCif .Or. _lVerPrFob .Or. _lVerPrCiD,.F.)}


Static function cliqueDireito(cType)

	do case
		case cType = "TP"
		oMenu01 	:= tMenu():new(0,0,0,0,.T.)
		oMenuItem 	:= tMenuItem():new(oMenu01,"Visualizar Cliente",,,,{|| funcoesDireito("CLI")},,,,,,,,,.T.)
		oMenu01:Add(oMenuItem)

		case cType = "ITP"
		oMenu01	:= tMenu():new(0,0,0,0,.T.)
		oMenuItem	:= tMenuItem():new(oMenu01,"Visualizar Produto",,,,{|| funcoesDireito("PRO")},,,,,,,,,.T.)
		oMenu01:Add(oMenuItem)

	endcase

return

Static function funcoesDireito(cType)

	do case
		case cType == "CLI"
		DbSelectArea("SA1")
		DbSetOrder(1)
		if MsSeek(xFilial("SA1")+oBrw:aArray[oBrw:nAt,01]+oBrw:aArray[oBrw:nAt,02])
			A030Visual("SA1",SA1->(Recno()),2)
		endif

		case cType == "PRO"
		DbSelectArea("SB1")
		DbSetOrder(1)
		if MsSeek(xFilial("SB1")+oBrw2:aArray[oBrw2:nAt,03])
			A010Visul("SB1",SB1->(Recno()),2)
		endif

	endcase

return

/*
//
// Juailson Semar - Rotina para gravar Registros reajustado da tabela de Obras(ZA2)
//   e caso o preço seja menor que o permitido grava registros para  Fazer a LIBERACAO DO PRECO DA OBRA
//
*/

Static function AjustarPrecoObra(p_aFiltro)
	Local _lEncont          := .F.
	Local cSQL_Obra			:= " "
	Local _cQ_Obra          := " "
	Local aObraFiltro       := {} // Array( len(p_aFiltro)) // Tem que a Mesma Estrutura para pode copia o array
	Local cNomeCampo        := " "
	Local _nCont := 0
	Local _lBloq := .F.
	// Montar Query
	for a:=1 to Len(p_aFiltro) // A T E N C A O  ESSA ROTINA É PARA FAZER COPIA DO ARRAY, POIS SE FIZER aObraFiltro := p_aFiltro, altera o aFiltro.
		AAdd(aObraFiltro,{p_aFiltro[a][1],;
		p_aFiltro[a][2],;
		p_aFiltro[a][3]})
	next

	for a:=1 to Len(aObraFiltro)

		if       aObraFiltro[a][1] == "ZH_CLIENTE"
			aObraFiltro[a][1] := "ZA2_CLIENT"
			cNomeCampo := "ZA2_CLIENT"
		elseif  aObraFiltro[a][1] == "ZH_LOJA"
			aObraFiltro[a][1] := "ZA2_LOJA"
			cNomeCampo := "ZA2_LOJA"
		elseif  aObraFiltro[a][1] == "A1_MUN"
			aObraFiltro[a][1] := "ZA2_MUNENT"
			cNomeCampo := "ZA2_MUNENT"
		elseif  aObraFiltro[a][1] == "A1_EST"
			aObraFiltro[a][1] := "ZA2_ESTENT"
			cNomeCampo := "ZA2_ESTENT"
		elseif  aObraFiltro[a][1] == "ZI_PRODUTO"
			aObraFiltro[a][1] := "ZA2_PRODUT"
			cNomeCampo := "ZA2_PRODUT"
		elseif  aObraFiltro[a][1] == "A1_VEND"
			aObraFiltro[a][1] := "ZA2_VEND"
			cNomeCampo := "ZA2_VEND"
		elseif  aObraFiltro[a][1] == "A1_FILIAL"
			aObraFiltro[a][1] := "ZA2_FILIAL"
			cNomeCampo := "ZA2_FILIAL"
		endif
		//

		do case
			case empty(aObraFiltro[a][2]) .and. !empty(aObraFiltro[a][3])
			cSQL_Obra  += " AND "+aObraFiltro[a][1]+" <= '"+aObraFiltro[a][3]+"' "

			case empty(aObraFiltro[a][3]) .and. !empty(aObraFiltro[a][2])
			cSQL_Obra += " AND "+aObraFiltro[a][1]+" >= '"+aObraFiltro[a][2]+"' "

			case !empty(aObraFiltro[a][2]) .and. !empty(aObraFiltro[a][3])
			cSQL_Obra += " AND "+aObraFiltro[a][1]+" BETWEEN '"+aObraFiltro[a][2]+"' AND '"+aObraFiltro[a][3]+"' "

		endcase
	next

	_cQ_Obra:= " SELECT * FROM " + RetSqlName("ZA2") + " Z	"
	_cQ_Obra+= " WHERE Z.D_E_L_E_T_ = '' AND Z.ZA2_LIBER = 'L' "

	_cQ_Obra+= cSQL_Obra   // Filtros escolhido pelo usuario -

	_cQ_Obra+= " ORDER BY ZA2_CLIENT, ZA2_LOJA, ZA2_PRODUT "

	TCQUERY _cQ_Obra NEW ALIAS "ZZ2"

	TCSETFIELD("ZZ2","ZI_DTBLOQ","D")

	ZZ2->(dbGotop())



	WHILE ZZ2->(!Eof())  // Temporaria  para ler Registros selecionados da tabela de OBRAS - 18/05/2015 Juailson Semar

		nCont := 0
		ZA2->(dbSetOrder(3))
		If ZA2->(msSeek(xFilial("ZA2")+ ZZ2->ZA2_CLIENT + ZZ2->ZA2_LOJA +  ZZ2->ZA2_OBRA))

			_cChav := ZA2->ZA2_CLIENTE + ZA2->ZA2_LOJA + ZA2->ZA2_OBRA
			//Pegar o ultimo item(sequencia) para somar + 1 na gravação
			WHILE ZA2->(!Eof())   .AND.  _cChav  == ZA2->ZA2_CLIENTE + ZA2->ZA2_LOJA + ZA2->ZA2_OBRA
				if (val(ZA2->ZA2_ITEM) > _nCont)
					_nCont := val(ZA2->ZA2_ITEM)
				endif
				ZA2->(dbSkip())
			ENDDO
			//
			_lBloq := .F.

			ZA2->(RecLock("ZA2",.T.))
			ZA2->ZA2_FILIAL  := xFilial("ZA2")
			ZA2->ZA2_CODIGO  := ZZ2->ZA2_CODIGO
			ZA2->ZA2_CLIENTE := ZZ2->ZA2_CLIENTE
			ZA2->ZA2_NOMCLI  := ZZ2->ZA2_NOMCLI
			ZA2->ZA2_LOJA    := ZZ2->ZA2_LOJA
			ZA2->ZA2_DTVIG   := dDataBase
			_nCont++
			ZA2->ZA2_ITEM    := strzero(_nCont,4)
			//	ZA2->ZA2_ITEM    := ZZ2->ZA2_ITEM
			ZA2->ZA2_OBRA    := ZZ2->ZA2_OBRA
			ZA2->ZA2_NOME    := ZZ2->ZA2_NOME
			ZA2->ZA2_PRODUT  := ZZ2->ZA2_PRODUT
			ZA2->ZA2_DESPRO  := ZZ2->ZA2_DESPRO
			ZA2->ZA2_VEND    := ZZ2->ZA2_VEND

			//Calcular os precos

			ZA2->ZA2_PRC01   := ZZ2->ZA2_PRC01
			ZA2->ZA2_PRC01D  := ZZ2->ZA2_PRC01D //Preco descarga Obra - Juailson - Semar 11/05/2015 -- ZA2_PRC01D
			ZA2->ZA2_PRC01F  := ZZ2->ZA2_PRC01F
			ZA2->ZA2_PRCGER  := ZZ2->ZA2_PRCGER
			ZA2->ZA2_PRUNIT  := ZZ2->ZA2_PRUNIT

			do case
				case nTipo == 1	//VALOR
				if nAcres == 1
					ZA2->ZA2_PRC01		:= ZA2->ZA2_PRC01	+ nCIF
					ZA2->ZA2_PRC01D		:= ZA2->ZA2_PRC01D + nCIFD //Juailson-Semar - Preco Cif Descarga - 23/01/15
					ZA2->ZA2_PRC01F	    := ZA2->ZA2_PRC01F	+ nFOB
					ZA2->ZA2_PRCGER		:= ZA2->ZA2_PRCGER	+ nGER
					ZA2->ZA2_PRUNIT	 := ZA2->ZA2_PRUNIT	+ nUNI
				else
					ZA2->ZA2_PRC01		:= ZA2->ZA2_PRC01	- nCIF
					ZA2->ZA2_PRC01D		:= ZA2->ZA2_PRC01D - nCIFD //Juailson-Semar - Preco Cif Descarga - 23/01/15
					ZA2->ZA2_PRC01F	:= ZA2->ZA2_PRC01F	- nFOB
					ZA2->ZA2_PRCGER		:= ZA2->ZA2_PRCGER	- nGER
					ZA2->ZA2_PRUNIT	:= ZA2->ZA2_PRUNIT	- nUNI
				endif

				case nTipo == 2	//PERCENTUAL
				if nAcres == 1
					ZA2->ZA2_PRC01		:= ZA2->ZA2_PRC01	+ (ZA2->ZA2_PRC01	* (nCIF/100) )
					ZA2->ZA2_PRC01D		:= ZA2->ZA2_PRC01D	+ (ZA2->ZA2_PRC01D * (nCIFD/100) ) //Juailson-Semar - Preco Cif Descarga - 23/01/15
					ZA2->ZA2_PRC01F	:= ZA2->ZA2_PRC01F	+ (ZA2->ZA2_PRC01F	* (nFOB/100) )
					ZA2->ZA2_PRCGER		:= ZA2->ZA2_PRCGER	+ (ZA2->ZA2_PRCGER	* (nGER/100) )
					ZA2->ZA2_PRUNIT	:= ZA2->ZA2_PRUNIT	+ (ZA2->ZA2_PRUNIT	* (nUNI/100) )
				else
					ZA2->ZA2_PRC01		:= ZA2->ZA2_PRC01	- (ZA2->ZA2_PRC01	* (nCIF/100) )
					ZA2->ZA2_PRC01D		:= ZA2->ZA2_PRC01D - (ZA2->ZA2_PRC01D	* (nCIFD/100) ) //Juailson-Semar - Preco Cif Descarga - 23/01/15
					ZA2->ZA2_PRC01F	:= ZA2->ZA2_PRC01F	- (ZA2->ZA2_PRC01F	* (nFOB/100) )
					ZA2->ZA2_PRCGER		:= ZA2->ZA2_PRCGER	- (ZA2->ZA2_PRCGER	* (nGER/100) )
					ZA2->ZA2_PRUNIT	:= ZA2->ZA2_PRUNIT	- (ZA2->ZA2_PRUNIT	* (nUNI/100) )
				endif

				case nTipo == 3	//ALINHAMENTO
				ZA2->ZA2_PRC01  	:= nCIF
				ZA2->ZA2_PRC01D 	:= nCIFD //Juailson-Semar - Preco Cif Descarga - 23/01/15
				ZA2->ZA2_PRC01F	:= nFOB
				ZA2->ZA2_PRCGER	:= nGER
				ZA2->ZA2_PRUNIT	:= nUNI
			endcase

			ZA2->ZA2_ENDENT  := ZZ2->ZA2_ENDENT
			ZA2->ZA2_MUNENT  := ZZ2->ZA2_MUNENT
			ZA2->ZA2_ESTENT  := ZZ2->ZA2_ESTENT
			ZA2->ZA2_BAIENT  := ZZ2->ZA2_BAIENT
			ZA2->ZA2_CEPENT  := ZZ2->ZA2_CEPENT
			ZA2->ZA2_TEL     := ZZ2->ZA2_TEL
			ZA2->ZA2_CONTATO := ZZ2->ZA2_CONTATO
			ZA2->ZA2_LIBER   := " "
			ZA2->ZA2_DTVIG   := Date()       //ZZ2->ZA2_DTVIG
			ZA2->ZA2_DTBLOQ  := Date() // ZZ2->ZA2_DTBLOQ
			ZA2->ZA2_INSCR   := ZZ2->ZA2_INSCR
			ZA2->(MsUnlock())

			_lLibera  := .F.
			_cAtivid  := ""
			_cProduto := ZA2->ZA2_PRODUT
			_cCliente := ZA2->ZA2_CLIENT
			_cLoja    := ZA2->ZA2_LOJA
			_cObra    := ZA2->ZA2_OBRA

			SA1->(dbSetOrder(1))
			SA1->(msSeek(xFilial("SA1")+ZA2->ZA2_CLIENTE + ZA2->ZA2_LOJA))

			SB1->(dbSetOrder(1))
			SB1->(msSeek(xFilial("SB1")+_cProduto))

			If Empty(ZA2->ZA2_LIBER) .And.  !Alltrim(SB1->B1_TIPCAR) $ "CDC"
				ZA4->(dbSetOrder(2))
				If ZA4->(!msSeek(xFilial("ZA4")+ZA2->ZA2_ESTENT         + SB1->B1_COD + SA1->A1_ATIVIDA + ZA2->ZA2_MUNENT))
					If ZA4->(!msSeek(xFilial("ZA4")+ZA2->ZA2_ESTENT     + SB1->B1_COD + SA1->A1_ATIVIDA ))
						If ZA4->(msSeek(xFilial("ZA4")+ZA2->ZA2_ESTENT  + SB1->B1_COD ))
							_lEncont :=.T.
						Endif
					Else
						_lEncont :=.T.
					Endif
				Else
					_lEncont :=.T.
				Endif

				_lVerPrCif := .F.
				_lVerPrCiD := .F.
				_lVerPrFob := .F.

				If ZA2->ZA2_PRC01 > 0
					If !_lEncont
						_lVerPrCif := .T.
					ElseIf ZA2->ZA2_PRC01 < ZA4->ZA4_VLMCIF
						_lVerPrCif := .T.
					ElseIf GETMV("MZ_LIBPRC")  // PARAMETRO PARA QUE FORÇA O BLOQUEIO DOS PREÇOS
						_lVerPrCif := .T.
					Endif
				Endif

				If ZA2->ZA2_PRC01D > 0 //Preco descarga Obra - Juailson - Semar 11/05/2015 -- ZA2_PRC01D
					If !_lEncont
						_lVerPrCiD := .T.
					ElseIf ZA2->ZA2_PRC01D < ZA4->ZA4_VLMCID
						_lVerPrCiD := .T.
					ElseIf GETMV("MZ_LIBPRC")  // PARAMETRO PARA QUE FORÇA O BLOQUEIO DOS PREÇOS
						_lVerPrCiD := .T.
					Endif
				Endif

				If ZA2->ZA2_PRC01F > 0
					If !_lEncont
						_lVerPrFob := .T.
					ElseIf ZA2->ZA2_PRC01F < ZA4->ZA4_VLMFOB
						_lVerPrFob := .T.
					ElseIf GETMV("MZ_LIBPRC")  // PARAMETRO PARA QUE FORÇA O BLOQUEIO DOS PREÇOS
						_lVerPrCif := .T.
					Endif
				Endif

				If _lVerPrCIF .Or. _lVerPrFob .Or. _lVerPrCID
					//SCR->(dbOrderNickName("INDSCR1"))
					//If SCR->(msSeek(xFilial("SCR")+"02"+SA1->A1_COD + SA1->A1_LOJA + SB1->B1_COD + ZA2->ZA2_OBRA + Space(08)))

					SCR->(dbOrderNickName("INDSCR5"))
					If SCR->(msSeek(xFilial("SCR")+"02"+ SB1->B1_COD + ZA2->ZA2_OBRA + ZA2->ZA2_CODIGO + ZA2->ZA2_ITEM + Space(07) + Space(08) ))

						//_cChavSCR := SCR->CR_YCLIENT + SCR->CR_YLOJA + SCR->CR_YPRODUT + SCR->CR_YOBRA + DTOS(SCR->CR_DATALIB)
						_cChavSCR := SCR->CR_TIPO + SCR->CR_NUM + DTOS(SCR->CR_DATALIB)

						//ZAH->(dbSetOrder(3))
						ZAH->(dbSetOrder(7))
						If ZAH->(msSeek(xFilial("ZAH")+ _cChavSCR  ))
							_cChavZAH := ZAH->ZAH_TIPO + ZAH->ZAH_NUM
							_cCrTipo  := SCR->CR_TIPO
							_cDocSCR  := SCR->CR_NUM

							_cCq := " DELETE "+RetSqlName("ZAH")+ " WHERE ZAH_NUM = '"+SCR->CR_NUM+"' AND ZAH_TIPO = '"+SCR->CR_TIPO+"' "
							_cCq += " AND ZAH_YCLIEN = '"+SCR->CR_YCLIENT +"' AND ZAH_YLOJA   = '"+SCR->CR_YLOJA+"' AND ZAH_YPRODU = '"+SCR->CR_YPRODUT+"' "
							_cCq += " AND ZAH_DATALI  = '"+DTOS(SCR->CR_DATALIB)+ "' AND ZAH_YOBRA = '"+SCR->CR_YOBRA+"' "
							TcSqlExec(_cCq)
						Endif

						//While SCR->(!Eof()) .And. _cChavSCR == SCR->CR_YCLIENT + SCR->CR_YLOJA + SCR->CR_YPRODUT + SCR->CR_YOBRA + DTOS(SCR->CR_DATALIB)
						While SCR->(!Eof()) .And. _cChavSCR == SCR->CR_TIPO + SCR->CR_NUM + DTOS(SCR->CR_DATALIB)

							SCR->(RecLock("SCR",.F.))
							SCR->(dbDelete())
							SCR->(MsUnlock())

							SCR->(dbSkip())
						EndDo
					Endif

					_cNum       := ZA2->ZA2_PRODUT + ZA2->ZA2_OBRA + ZA2->ZA2_CODIGO + ZA2->ZA2_ITEM
					lFirstNiv   := .T.
					cAuxNivel   := ""
					_lLibera    := .T.

					SAL->(dbSetOrder(2))
					If SAL->(msSeek(xFilial()+_cGrAprov))

						While SAL->(!Eof()) .And. xFilial("SAL")+_cGrAprov == SAL->AL_FILIAL+SAL->AL_COD

							If lFirstNiv
								cAuxNivel := SAL->AL_NIVEL
								lFirstNiv := .F.
							EndIf

							SCR->(Reclock("SCR",.T.))
							SCR->CR_FILIAL	:= xFilial("SCR")
							SCR->CR_NUM		:= _cNum
							SCR->CR_TIPO	:= "02"
							SCR->CR_NIVEL	:= SAL->AL_NIVEL
							SCR->CR_USER	:= SAL->AL_USER
							SCR->CR_APROV	:= SAL->AL_APROV
							SCR->CR_STATUS	:= "02"//IIF(SAL->AL_NIVEL == cAuxNivel,"02","01")
							SCR->CR_EMISSAO := dDataBase
							SCR->CR_MOEDA	:= 1
							SCR->CR_TXMOEDA := 1
							SCR->CR_OBS     := Alltrim(SM0->M0_NOME) + " - TABELA DE PRECO VENDAS (OBRA)"

							If _lVerPrCif
								If ZA2->ZA2_PRC01 < ZA4->ZA4_VLMCIF .Or. !_lEncont
									SCR->CR_YREFCIF := ZA4->ZA4_VLMCIF
									SCR->CR_YPRCCIF := ZA2->ZA2_PRC01
									SCR->CR_TOTAL	:= ZA2->ZA2_PRC01
								Endif
							Endif

							If _lVerPrCiD  //Preco descarga Obra - Juailson - Semar 11/05/2015 -- ZA2_PRC01D
								If ZA2->ZA2_PRC01D < ZA4->ZA4_VLMCID .Or. !_lEncont
									SCR->CR_YREFCID := ZA4->ZA4_VLMCID
									SCR->CR_YPRCCID := ZA2->ZA2_PRC01D
									SCR->CR_TOTAL	:= ZA2->ZA2_PRC01D
								Endif
							Endif


							If _lVerPrFob
								If ZA2->ZA2_PRC01F < ZA4->ZA4_VLMFOB .Or. !_lEncont
									SCR->CR_YREFFOB := ZA4->ZA4_VLMFOB
									SCR->CR_YPRCFOB := ZA2->ZA2_PRC01F
									SCR->CR_TOTAL	:= ZA2->ZA2_PRC01F
								Endif
							Endif

							If ZA2->ZA2_PRCGER   < ZA4->ZA4_VLMGER
								SCR->CR_YREFGER := ZA4->ZA4_VLMGER
								SCR->CR_YPRCGER := ZA2->ZA2_PRCGER
								SCR->CR_TOTAL	:= ZA2->ZA2_PRCGER
							Endif
							SCR->CR_YCLIENT := ZA2->ZA2_CLIENT
							SCR->CR_YLOJA   := ZA2->ZA2_LOJA
							SCR->CR_YPRODUT := ZA2->ZA2_PRODUT
							SCR->CR_YOBRA   := ZA2->ZA2_OBRA

							SCR->(MsUnlock())

							ZAH->(RecLock("ZAH",.T.))
							ZAH->ZAH_FILIAL:= SCR->CR_FILIAL
							ZAH->ZAH_NUM   := SCR->CR_NUM
							ZAH->ZAH_TIPO  := SCR->CR_TIPO
							ZAH->ZAH_NIVEL := SCR->CR_NIVEL
							ZAH->ZAH_USER  := SCR->CR_USER
							ZAH->ZAH_APROV := SCR->CR_APROV
							ZAH->ZAH_STATUS:= SCR->CR_STATUS
							ZAH->ZAH_TOTAL := SCR->CR_TOTAL
							ZAH->ZAH_EMISSA:= SCR->CR_EMISSAO
							ZAH->ZAH_MOEDA := SCR->CR_MOEDA
							ZAH->ZAH_TXMOED:= SCR->CR_TXMOEDA
							ZAH->ZAH_YREFCI:= SCR->CR_YREFCIF
							ZAH->ZAH_YPRCCI:= SCR->CR_YPRCCIF
							ZAH->ZAH_YREFCD := SCR->CR_YREFCID //Ref Cif Descarga - Juailson Semar 11/05/2015
							ZAH->ZAH_YPRCCD := SCR->CR_YPRCCID // Preco Cif Descarga -  Juailson Semar 11/05/2015
							ZAH->ZAH_TOTAL := SCR->CR_TOTAL
							ZAH->ZAH_YREFFO:= SCR->CR_YREFFOB
							ZAH->ZAH_YPRCFO:= SCR->CR_YPRCFOB
							ZAH->ZAH_YREFGE:= SCR->CR_YREFGER
							ZAH->ZAH_YPRCGE:= SCR->CR_YPRCGER
							ZAH->ZAH_YCLIEN:= SCR->CR_YCLIENT
							ZAH->ZAH_YLOJA := SCR->CR_YLOJA
							ZAH->ZAH_YPRODU:= SCR->CR_YPRODUT
							ZAH->ZAH_YOBRA := SCR->CR_YOBRA
							ZAH->(MsUnlock())


							SAL->(dbSkip())
						EndDo
					EndIf
				Endif
			Endif

			_aAliZA2 := ZA2->(GetArea()) // Salva area e Bloqueia o Produto Liberado
			ZA2->(dbSetOrder(2))
			If ZA2->(msSeek(xFilial("ZA2")+ _cCliente + _cLoja + _cProduto + _cObra +"L"))
				ZA2->(RecLock("ZA2",.F.))
				ZA2->ZA2_LIBER  := "B"
				ZA2->ZA2_DTBLOQ := Date()
				ZA2->(MsUnLock())
			Endif
			RestArea(_aAliZA2) // Restaura

			If !_lLibera .Or. Alltrim(SB1->B1_TIPCAR) $ "CDC"  // Pegar o registro ZA2 da Memoria e Libera
				ZA2->(RecLock("ZA2",.F.))
				ZA2->ZA2_LIBER   := "L"
				ZA2->ZA2_DTVIG   := Date()
				ZA2->ZA2_DTBLOQ  := CTOD("")
				ZA2->(MsUnLock())
			Else
				_lBloq := .T.
			Endif
		Endif

		ZZ2->(DbSkip())
	ENDDO

	If  _lBloq
		MSGINFO("PRECO OBRA BLOQUEADO, FAVOR SOLICITAR LIBERACAO!!!")
	Endif

	ZZ2->(DbCloseArea())

Return

//
Static Function PergRest()

	_sAlias := getArea()
	dbSelectArea("SX1")
	dbSetOrder(1)
	cPerg2 := PadR(cPerg2,10)

	aRegs:={}
	//1     2     3        4        5    6       7       8      9   10    11
	//Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05/F3
	//          1     2    3                              4       5   6  7 8  9  10
	// COM COMBO                                                             C                              port1   esp1     ing1          port2   esp2    ing2
	aAdd(aRegs,{cPerg2,"01","Reajustar ?","","","mv_ch1","C",01,1,0,"C","              ","mv_par01","Tabela Preco","Tabela Preco","Tabela Preco","","","Preco Obra","Preco Obra","Preco Obra","","","Ambos","Ambos","Ambos","","","","","","","","","","","","",""})

	For i:=1 to Len(aRegs)
		If !msSeek(cPerg2+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Endif
	Next
	restArea(_sAlias)

Return