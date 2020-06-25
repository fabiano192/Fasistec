#INCLUDE 'PROTHEUS.CH' 
#Include "Topconn.ch"
#INCLUDE "RWMAKE.CH"
#include "TbiConn.ch"
#include "TbiCode.ch"
/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥ PXH063  ∫Autor ≥JosÈ Augusto - Tripex Labs | Data:22/09/14 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Programa de Imp. dos dados da tabela SZQ					  ∫±±
±±∫          ≥ EspecÌfico: ASSYSTEM                                       ∫±±
±±∫          ≥ Tipo Relatorio: TREPORT									  ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

User Function PXH063()

Local oReport
Local cPerg  := 'PXH063'
Local cAlias := getNextAlias()
Local aEmp := {} 

Private cEmpr := ""

criaSx1(cPerg)
Pergunte(cPerg, .F.)

oReport := reportDef(cPerg)
oReport:printDialog()

return
      
*------------------------
Static Function MontaQry()
*------------------------  
Local cQry := "" 
Local cOrigemDe  := "" 
Local cOrigemAte := ""

If MV_PAR15 == 1 
	cOrigemDe  := ""
	cOrigemAte := "ZZZ"
ElseIf MV_PAR15 == 2  
	cOrigemDe  := "SD1"
	cOrigemAte := "SD1"
ElseIf MV_PAR15 == 3  
	cOrigemDe  := "SE5"
	cOrigemAte := "SE5"
ElseIf MV_PAR15 == 4  
	cOrigemDe  := "FOL"
	cOrigemAte := "FOL"		
ElseIf MV_PAR15 == 5  
	cOrigemDe  := "EXT"
	cOrigemAte := "EXT"      
EndIf

cQry := "SELECT " 
cQry += "ZQ_NOMEMP, "
cQry += "ZQ_DTDIGIT, " 
cQry += "ZQ_EMISSAO, "
cQry += "ZQ_ANOMES, "
cQry += "ZQ_PREFIXO, "
cQry += "ZQ_NUM, "
cQry += "ZQ_PARCELA, "	
cQry += "ZQ_TIPO, "
cQry += "ZQ_ESPECIE, "	
cQry += "ZQ_QUANT, "	 
cQry += "ZQ_TOTAL, "
cQry += "ZQ_CUSCTB, " 	
cQry += "ZQ_VALLIQ, "	
cQry += "ZQ_VALDESC, "	
cQry += "ZQ_FORNECE, " 	
cQry += "ZQ_LOJA, "	
cQry += "ZQ_NOME, "	
cQry += "ZQ_OBS, "	
cQry += "ZQ_CONTA, "	
cQry += "ZQ_DCONTA, "	
cQry += "ZQ_YCC, "	
cQry += "ZQ_DCUSTO, "	
cQry += "ZQ_ITEMCTA, "	
cQry += "ZQ_DITEMC, "	
cQry += "ZQ_PRODUTO, "	
cQry += "ZQ_DESCRIC, " 	
cQry += "ZQ_CF, "	
cQry += "ZQ_NATUREZ, "	
cQry += "ZQ_VENCTO, "	
cQry += "ZQ_NATSYS, "	
cQry += "ZQ_COND, "	
cQry += "ZQ_TES, "	
cQry += "ZQ_PEDIDO, "	
cQry += "ZQ_FILIAL, " 	
cQry += "ZQ_TEXTO, "	
cQry += "ZQ_ITEMPC, "	
cQry += "ZQ_DUPLIC, "	
cQry += "ZQ_CODEMP, "	
cQry += "ZQ_VENCREA, "	
cQry += "ZQ_BAIXA, "	
cQry += "ZQ_VALIPI, "	
cQry += "ZQ_CLVL, "	
cQry += "ZQ_MUN, "	
cQry += "ZQ_EST, "	
cQry += "ZQ_VALICM, "	
cQry += "ZQ_INSS, "	
cQry += "ZQ_DITEMC, "	
cQry += "ZQ_IRRF, "	
cQry += "ZQ_VALISS, "	
cQry += "ZQ_DESPESA, "	
cQry += "ZQ_SEGURO, "	
cQry += "ZQ_VRETPIS, "	
cQry += "ZQ_VRETCOF, "	
cQry += "ZQ_VRETCSL, "	
cQry += "ZQ_VCRDPIS, "	
cQry += "ZQ_VCRDCOF, "	
cQry += "ZQ_VCRDCSL, " 
cQry += "ZQ_DESCORI, "	
cQry += "ZQ_CODVISA, "	
cQry += "ZQ_DESVISA, "	
cQry += "ZQ_CODVISS, "	
cQry += "ZQ_DESVISS, "	
cQry += "ZQ_CONTVIS "                                                  		
cQry += "FROM "+RetSqlName("SZQ")+" SZQ        	   	   			   					"
cQry += "WHERE D_E_L_E_T_ <> '*'									   				" 									
cQry += "AND ZQ_DTDIGIT BETWEEN '"+DtoS(MV_PAR01)+"'  AND '"+DtoS(MV_PAR02)+"'   	"
//cQry += "AND ZQ_FILIAL  BETWEEN '"+MV_PAR05+"'  AND '"+MV_PAR06+"'     				"
cQry += "AND ZQ_CONTA   BETWEEN '"+MV_PAR07+"'  AND '"+MV_PAR08+"'     				"
cQry += "AND ZQ_YCC     BETWEEN '"+MV_PAR09+"'  AND '"+MV_PAR10+"'   				"
cQry += "AND ZQ_TES     BETWEEN '"+MV_PAR11+"'  AND '"+MV_PAR12+"'   				"  
cQry += "AND ZQ_NATUREZ BETWEEN '"+MV_PAR13+"'  AND '"+MV_PAR14+"'     				" 
cQry += "AND ZQ_ORIG    BETWEEN '"+cOrigemDe+"' AND '"+cOrigemAte+"'   				" 

If cEmpr <> "Todas"
	cQry += "AND ZQ_CODEMP IN ("+cEmpr+")								" 
Else
	cQry += "AND ZQ_CODEMP    BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
EndiF 									   			"    

IIF(SELECT("QRY1")>0,QRY1->(dbCloseArea()),)
TcQuery cQry New Alias "QRY1"
                                      
Return        
        
//+-----------------------------------------------------------------------------------------------+
//! Rotina para montagem dos dados do relatÛrio.                                  !
//+-----------------------------------------------------------------------------------------------+
Static Function ReportPrint(oReport)
              
Local oSection1 := oReport:Section(1)

	oSection1:Init()
	oSection1:SetHeaderSection(.T.)

	VerEmp()

	MontaQry()

	DbSelectArea('QRY1')
	QRY1->(DbGoTop())
	oReport:SetMeter(QRY1->(RecCount()))
	While QRY1->(!Eof())
		If oReport:Cancel()
			Exit
		EndIf
 
		oReport:IncMeter()
        
		oSection1:Cell("ZQ_NOMEMP"):SetValue(Alltrim(QRY1->ZQ_NOMEMP))
		oSection1:Cell("ZQ_DTDIGIT"):SetValue(Alltrim(QRY1->ZQ_DTDIGIT))
		oSection1:Cell("ZQ_EMISSAO"):SetValue(Alltrim(QRY1->ZQ_EMISSAO))
		oSection1:Cell("ZQ_ANOMES"):SetValue(Alltrim(QRY1->ZQ_ANOMES))
		oSection1:Cell("ZQ_PREFIXO"):SetValue(Alltrim(QRY1->ZQ_PREFIXO))
		oSection1:Cell("ZQ_NUM"):SetValue(Alltrim(QRY1->ZQ_NUM))
		oSection1:Cell("ZQ_PARCELA"):SetValue(Alltrim(QRY1->ZQ_PARCELA))
		oSection1:Cell("ZQ_TIPO"):SetValue(Alltrim(QRY1->ZQ_TIPO))                	
		oSection1:Cell("ZQ_ESPECIE"):SetValue(Alltrim(QRY1->ZQ_ESPECIE)) 
		oSection1:Cell("ZQ_QUANT"):SetValue(QRY1->ZQ_QUANT)
		oSection1:Cell("ZQ_TOTAL"):SetValue(QRY1->ZQ_TOTAL)
		oSection1:Cell("ZQ_CUSCTB"):SetValue(QRY1->ZQ_CUSCTB)
		oSection1:Cell("ZQ_VALLIQ"):SetValue(QRY1->ZQ_VALLIQ)
		oSection1:Cell("ZQ_VALDESC"):SetValue(QRY1->ZQ_VALDESC)
		oSection1:Cell("ZQ_FORNECE"):SetValue(Alltrim(QRY1->ZQ_FORNECE))
		oSection1:Cell("ZQ_LOJA"):SetValue(Alltrim(QRY1->ZQ_LOJA))
		oSection1:Cell("ZQ_NOME"):SetValue(Alltrim(QRY1->ZQ_NOME))
		oSection1:Cell("ZQ_OBS"):SetValue(Alltrim(QRY1->ZQ_OBS))
		oSection1:Cell("ZQ_CONTA"):SetValue(Alltrim(QRY1->ZQ_CONTA))
		oSection1:Cell("ZQ_DCONTA"):SetValue(Alltrim(QRY1->ZQ_DCONTA))
		oSection1:Cell("ZQ_YCC"):SetValue(Alltrim(QRY1->ZQ_YCC))
		oSection1:Cell("ZQ_DCUSTO"):SetValue(Alltrim(QRY1->ZQ_DCUSTO))
		oSection1:Cell("ZQ_ITEMCTA"):SetValue(Alltrim(QRY1->ZQ_ITEMCTA))
		oSection1:Cell("ZQ_DITEMC"):SetValue(Alltrim(QRY1->ZQ_DITEMC))
		oSection1:Cell("ZQ_PRODUTO"):SetValue(Alltrim(QRY1->ZQ_PRODUTO))
		oSection1:Cell("ZQ_DESCRIC"):SetValue(Alltrim(QRY1->ZQ_DESCRIC))
		oSection1:Cell("ZQ_CF"):SetValue(Alltrim(QRY1->ZQ_CF))
		oSection1:Cell("ZQ_NATUREZ"):SetValue(Alltrim(QRY1->ZQ_NATUREZ))
		oSection1:Cell("ZQ_VENCTO"):SetValue(Alltrim(QRY1->ZQ_VENCTO))
		oSection1:Cell("ZQ_NATSYS"):SetValue(Alltrim(QRY1->ZQ_NATSYS))
		oSection1:Cell("ZQ_COND"):SetValue(Alltrim(QRY1->ZQ_COND))
		oSection1:Cell("ZQ_TES"):SetValue(Alltrim(QRY1->ZQ_TES))
		oSection1:Cell("ZQ_PEDIDO"):SetValue(Alltrim(QRY1->ZQ_PEDIDO))
		oSection1:Cell("ZQ_FILIAL"):SetValue(Alltrim(QRY1->ZQ_FILIAL))
		oSection1:Cell("ZQ_TEXTO"):SetValue(Alltrim(QRY1->ZQ_TEXTO))
		oSection1:Cell("ZQ_ITEMPC"):SetValue(Alltrim(QRY1->ZQ_ITEMPC))
		oSection1:Cell("ZQ_DUPLIC"):SetValue(Alltrim(QRY1->ZQ_DUPLIC))
		oSection1:Cell("ZQ_CODEMP"):SetValue(Alltrim(QRY1->ZQ_CODEMP))
		oSection1:Cell("ZQ_VENCREA"):SetValue(Alltrim(QRY1->ZQ_VENCREA))
		oSection1:Cell("ZQ_BAIXA"):SetValue(Alltrim(QRY1->ZQ_BAIXA))   
		oSection1:Cell("ZQ_VALIPI"):SetValue(QRY1->ZQ_VALIPI)
		oSection1:Cell("ZQ_CLVL"):SetValue(Alltrim(QRY1->ZQ_CLVL))
		oSection1:Cell("ZQ_MUN"):SetValue(Alltrim(QRY1->ZQ_MUN))
		oSection1:Cell("ZQ_EST"):SetValue(Alltrim(QRY1->ZQ_EST))
		oSection1:Cell("ZQ_VALICM"):SetValue(QRY1->ZQ_VALICM)
		oSection1:Cell("ZQ_INSS"):SetValue(QRY1->ZQ_INSS)
		oSection1:Cell("ZQ_DITEMC"):SetValue(Alltrim(QRY1->ZQ_DITEMC))
		oSection1:Cell("ZQ_IRRF"):SetValue(QRY1->ZQ_IRRF)
		oSection1:Cell("ZQ_VALISS"):SetValue(QRY1->ZQ_VALISS)
		oSection1:Cell("ZQ_DESPESA"):SetValue(QRY1->ZQ_DESPESA)
		oSection1:Cell("ZQ_SEGURO"):SetValue(QRY1->ZQ_SEGURO)
		oSection1:Cell("ZQ_VRETPIS"):SetValue(QRY1->ZQ_VRETPIS)
		oSection1:Cell("ZQ_VRETCOF"):SetValue(QRY1->ZQ_VRETCOF)
		oSection1:Cell("ZQ_VRETCSL"):SetValue(QRY1->ZQ_VRETCSL) 
		oSection1:Cell("ZQ_VCRDPIS"):SetValue(QRY1->ZQ_VCRDPIS)
		oSection1:Cell("ZQ_VCRDCOF"):SetValue(QRY1->ZQ_VCRDCOF)
		oSection1:Cell("ZQ_VRETCSL"):SetValue(QRY1->ZQ_VRETCSL)
		oSection1:Cell("ZQ_VCRDPIS"):SetValue(QRY1->ZQ_VCRDPIS)
		oSection1:Cell("ZQ_VCRDCOF"):SetValue(QRY1->ZQ_VCRDCOF)
		oSection1:Cell("ZQ_VCRDCSL"):SetValue(QRY1->ZQ_VCRDCSL)
		oSection1:Cell("ZQ_DESCORI"):SetValue(Alltrim(QRY1->ZQ_DESCORI))
		oSection1:Cell("ZQ_CODVISA"):SetValue(Alltrim(QRY1->ZQ_CODVISA))
		oSection1:Cell("ZQ_DESVISA"):SetValue(Alltrim(QRY1->ZQ_DESVISA))
		oSection1:Cell("ZQ_CODVISS"):SetValue(Alltrim(QRY1->ZQ_CODVISS))
		oSection1:Cell("ZQ_DESVISS"):SetValue(Alltrim(QRY1->ZQ_DESVISS)) 
		oSection1:Cell("ZQ_CONTVIS"):SetValue(Alltrim(QRY1->ZQ_CONTVIS))
		oSection1:Cell("ZQ_NOMEMP"):SetValue(Alltrim(QRY1->ZQ_NOMEMP))
		
		oSection1:PrintLine()
		
		dbSelectArea("QRY1")
		QRY1->(dbSkip())
	EndDo
	oSection1:Finish() 

return

//+-----------------------------------------------------------------------------------------------+
//! FunÁ„o para criaÁ„o da estrutura do relatÛrio.                                                !
//+-----------------------------------------------------------------------------------------------+
Static Function ReportDef(cPerg)

local cTitle  := "Resumo por Centro de Custo"
local cHelp   := "Permite gerar relatÛrio Resumo por CC."
local oReport
local oSection1

oReport := TReport():New('PXH063',cTitle,cPerg,{|oReport|ReportPrint(oReport)},cHelp)
oReport:SetPortrait()
oReport:SetTotalInLine(.F.)
oReport:ShowHeader()

//Primeira seÁ„o
oSection1 := TRSection():New(oReport,"RESUMO POR CC",{"QRY1"})  



TRCell():New(oSection1,"ZQ_NOMEMP", 	"QRY1", "Nome Empresa")
TRCell():New(oSection1,"ZQ_DTDIGIT", 	"QRY1", "DT Digitacao")     
TRCell():New(oSection1,"ZQ_EMISSAO", 	"QRY1", "Emissao") 
TRCell():New(oSection1,"ZQ_ANOMES", 	"QRY1", "Ano Mes") 
TRCell():New(oSection1,"ZQ_PREFIXO", 	"QRY1", "Prefixo") 
TRCell():New(oSection1,"ZQ_NUM", 		"QRY1", "Numero") 
TRCell():New(oSection1,"ZQ_PARCELA", 	"QRY1", "Parcela") 
TRCell():New(oSection1,"ZQ_TIPO", 		"QRY1", "Tipo") 
TRCell():New(oSection1,"ZQ_ESPECIE", 	"QRY1", "Espec.Docum.") 
TRCell():New(oSection1,"ZQ_QUANT", 		"QRY1", "Quantidade")  
TRCell():New(oSection1,"ZQ_TOTAL", 		"QRY1", "Total") 
TRCell():New(oSection1,"ZQ_CUSCTB", 	"QRY1", "CM contabil") 
TRCell():New(oSection1,"ZQ_VALLIQ", 	"QRY1", "Vr. Liquido") 
TRCell():New(oSection1,"ZQ_VALDESC", 	"QRY1", "Desconto") 
TRCell():New(oSection1,"ZQ_FORNECE", 	"QRY1", "Fornecedor") 
TRCell():New(oSection1,"ZQ_LOJA", 		"QRY1", "Loja") 
TRCell():New(oSection1,"ZQ_NOME", 		"QRY1", "Nome") 
TRCell():New(oSection1,"ZQ_OBS", 		"QRY1", "Observacoes") 
TRCell():New(oSection1,"ZQ_CONTA", 		"QRY1", "Conta") 
TRCell():New(oSection1,"ZQ_DCONTA", 	"QRY1", "Desc. Conta") 
TRCell():New(oSection1,"ZQ_YCC", 		"QRY1", "C. Custo") 
TRCell():New(oSection1,"ZQ_DCUSTO", 	"QRY1", "Desc.C.Custo") 
TRCell():New(oSection1,"ZQ_ITEMCTA", 	"QRY1", "Item CTA") 
TRCell():New(oSection1,"ZQ_DITEMC", 	"QRY1", "Des.Item Ctb") 
TRCell():New(oSection1,"ZQ_PRODUTO", 	"QRY1", "Produto") 
TRCell():New(oSection1,"ZQ_DESCRIC", 	"QRY1", "Descricao") 
TRCell():New(oSection1,"ZQ_CF", 		"QRY1", "Cod. Fiscal") 
TRCell():New(oSection1,"ZQ_NATUREZ", 	"QRY1", "Natureza") 
TRCell():New(oSection1,"ZQ_VENCTO", 	"QRY1", "Vencto") 
TRCell():New(oSection1,"ZQ_NATSYS", 	"QRY1", "Nat.SYS") 
TRCell():New(oSection1,"ZQ_COND", 		"QRY1", "Cond. Pagto") 
TRCell():New(oSection1,"ZQ_TES", 		"QRY1", "Tipo Entrada") 
TRCell():New(oSection1,"ZQ_PEDIDO", 	"QRY1", "No do Pedido") 
TRCell():New(oSection1,"ZQ_FILIAL", 	"QRY1", "Filial") 
TRCell():New(oSection1,"ZQ_TEXTO", 		"QRY1", "Txt Padrao") 
TRCell():New(oSection1,"ZQ_ITEMPC", 	"QRY1", "Item do Ped.") 
TRCell():New(oSection1,"ZQ_DUPLIC", 	"QRY1", "Gera Dupl. ?") 
TRCell():New(oSection1,"ZQ_CODEMP", 	"QRY1", "Cod Empresa") 
TRCell():New(oSection1,"ZQ_VENCREA", 	"QRY1", "Vencto Real") 
TRCell():New(oSection1,"ZQ_BAIXA", 		"QRY1", "Baixa") 
TRCell():New(oSection1,"ZQ_VALIPI", 	"QRY1", "Valor IPI") 
TRCell():New(oSection1,"ZQ_CLVL", 		"QRY1", "Class. Valor") 
TRCell():New(oSection1,"ZQ_MUN", 		"QRY1", "Municipio") 
TRCell():New(oSection1,"ZQ_EST", 		"QRY1", "Estado")   
TRCell():New(oSection1,"ZQ_VALICM", 	"QRY1", "Vr. ICM") 
TRCell():New(oSection1,"ZQ_INSS", 		"QRY1", "INSS") 
TRCell():New(oSection1,"ZQ_DITEMC", 	"QRY1", "Classe") 
TRCell():New(oSection1,"ZQ_IRRF", 		"QRY1", "IRRF") 
TRCell():New(oSection1,"ZQ_VALISS", 	"QRY1", "Valor do ISS") 
TRCell():New(oSection1,"ZQ_DESPESA", 	"QRY1", "Vlr. Despesa") 
TRCell():New(oSection1,"ZQ_SEGURO", 	"QRY1", "Vlr. Seguro") 
TRCell():New(oSection1,"ZQ_VRETPIS", 	"QRY1", "Vlr Ret PIS") 
TRCell():New(oSection1,"ZQ_VRETCOF", 	"QRY1", "Vlr Ret COF") 
TRCell():New(oSection1,"ZQ_VRETCSL", 	"QRY1", "Vlr Ret CSLL") 
TRCell():New(oSection1,"ZQ_VCRDPIS", 	"QRY1", "Vlr Crd PIS") 
TRCell():New(oSection1,"ZQ_VCRDCOF", 	"QRY1", "Vlr Crd COF") 
TRCell():New(oSection1,"ZQ_VCRDCSL", 	"QRY1", "Vl Cred CSLL") 
TRCell():New(oSection1,"ZQ_DESCORI", 	"QRY1", "Desc.Origem") 
TRCell():New(oSection1,"ZQ_CODVISA", 	"QRY1", "Cod.Visao An") 
TRCell():New(oSection1,"ZQ_DESVISA", 	"QRY1", "Desc.Vis.An.") 
TRCell():New(oSection1,"ZQ_CODVISS", 	"QRY1", "Cod.Vis.Sint") 
TRCell():New(oSection1,"ZQ_DESVISS", 	"QRY1", "Des.Vis.Sint") 
TRCell():New(oSection1,"ZQ_CONTVIS", 	"QRY1", "Cont.Visao") 
                                           
Return(oReport)

//+-----------------------------------------------------------------------------------------------+
//! FunÁ„o para criaÁ„o das perguntas (se n„o existirem)                                          !
//+-----------------------------------------------------------------------------------------------+
static function criaSX1(cPerg)

putSx1(cPerg, '01', 'Dt Digitacao De?'          , '', '', 'mv_ch1',  'D', 8,  0, 0, 'G', '', ''   , '', '', 'mv_par01') 
putSx1(cPerg, '02', 'Dt Digitacao Ate?'         , '', '', 'mv_ch2',  'D', 8,  0, 0, 'G', '', ''   , '', '', 'mv_par02') 
putSx1(cPerg, '03', 'Empresa De?'        		, '', '', 'mv_ch3',  'C', 5,  0, 0, 'G', '', ''   , '', '', 'mv_par03')
putSx1(cPerg, '04', 'Empresa Ate?'       		, '', '', 'mv_ch4',  'C', 5,  0, 0, 'G', '', ''   , '', '', 'mv_par04') 
putSx1(cPerg, '05', 'Filial De?'        		, '', '', 'mv_ch5',  'C', 3,  0, 0, 'G', '', ''   , '', '', 'mv_par05')
putSx1(cPerg, '06', 'Filial Ate?'       		, '', '', 'mv_ch6',  'C', 3,  0, 0, 'G', '', ''   , '', '', 'mv_par06')
putSx1(cPerg, '07', 'Conta De?'       			, '', '', 'mv_ch7',  'C', 20, 0, 0, 'G', '', 'CT1', '', '', 'mv_par07') 
putSx1(cPerg, '08', 'Conta Ate?'        		, '', '', 'mv_ch8',  'C', 20, 0, 0, 'G', '', 'CT1', '', '', 'mv_par08') 
putSx1(cPerg, '09', 'Centro de Custo De?'       , '', '', 'mv_ch9',  'C', 9,  0, 0, 'G', '', 'CTT', '', '', 'mv_par09') 
putSx1(cPerg, '10', 'Centro de Custo Ate?'      , '', '', 'mv_ch10', 'C', 9,  0, 0, 'G', '', 'CTT', '', '', 'mv_par10')  
putSx1(cPerg, '11', 'TES De?'       			, '', '', 'mv_ch11', 'C', 3,  0, 0, 'G', '', 'SF4', '', '', 'mv_par11') 
putSx1(cPerg, '12', 'TES Ate?'       			, '', '', 'mv_ch12', 'C', 3,  0, 0, 'G', '', 'SF4', '', '', 'mv_par12') 
putSx1(cPerg, '13', 'Natureza De?'       		, '', '', 'mv_ch13', 'C', 10, 0, 0, 'G', '', 'SED', '', '', 'mv_par13')
putSx1(cPerg, '14', 'Natureza Ate?'       		, '', '', 'mv_ch14', 'C', 10, 0, 0, 'G', '', 'SED', '', '', 'mv_par14')
putSx1(cPerg, '15', 'Origem?'       			, '', '', 'mv_ch15', 'C', 10, 0, 0, 'C', '', ''   , '', '', 'mv_par15','Todas',,,,'Compras',,,'Mov. Bancaria',,,'Folha',,,'Extras',,)


return 

//+------------------------------------------------------------------------------
Static Function VerEmp()

Local lRetSenha := .F.
Local aUsuarios	:= {}
Local lOkEmp 	:= .F.                       
Local cTxtEmp	:= ""  
Local aEmpMaisF := {}      

Local cNome := USRRETNAME(RETCODUSR())          
Local nAchou := 0
 	
	aUsuarios := AllUsers(.T.)

	For x:= 1 To Len(aUsuarios)
		If Lower(AllTrim(aUsuarios[x,01,02])) == Lower(AllTrim(cNome))
			PswOrder(2)
			PswSeek(aUsuarios[x,01,02],.T.)
			aEmpMaisF	:= aUsuarios[x,02,06]   // EMPRESAS QUE TEM ACESSO                                                       
		EndIf
	Next x                                                 
	
	For i:=1 To Len(aEmpMaisF)
		If aEmpMaisF[1] == "@@@@"'
			cEmpr := "Todas"
		Else 
			If !Empty(Alltrim(cEmpr))         
				cEmpr += ","
			EndiF
			cEmpr += "'"+Substr(aEmpMaisF[i],1,5)+"'"
		EndIf
	Next
	                
Return