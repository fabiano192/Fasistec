#include "rwmake.ch"
#Include "PROTHEUS.CH"
#INCLUDE "topconn.ch"


User function PXH022()

Local oDlg5
local aSays		:=	{}
local aButtons 	:= 	{}
local nOpca 	:= 	0
local cCadastro	:= 	"Relação Resumo dos Centros de Custo"

Private clog    := ''
Private cPergC  := PadR('RESCC02_C',10)//PARAMETROS
Private cPergF  := PadR('RESCC02_F',10)//FILTRO
private ccaminho:= 'c:\'

//SetSX1(cPergF,'PAR_FILTRO' )

lProsseguir:=.f.

AADD(aSays,"Este programa gera um Relatorio do Resumo dos Centros de Custo, para analise gerencial. ")
AADD(aSays,"O relatorio analisa parametros de usario pre-definidos, bem como, os parametros de filtro dinamicos")
AADD(aSays,"     ")
AADD(aSays,"	 " )
AADD(aSays,"Oberve os parametros antes de gerar o arquivo!")
AADD(aSays,"Específico - HOLDING")
//AADD(aButtons, { 5,.T.,{||  frmCadZZF() } } )	//configuração
AADD(aButtons, {17,.T.,{||  pergunte(cpergF,.t.) } } )	 //filtro
AADD(aButtons, { 1,.T.,{|o| Processa( {|| RELRESCC( nOpca:= 1, cPergF ),"Aguarde..." } )  } } )
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )


formBatch( cCadastro, aSays, aButtons ,,450  ,550 )

Return


Static Function RELRESCC(p_nOpcao, p_cPergF)

Local oReport
Local wArea	:= GetArea()

Private	oBrush		:= TBrush():New(,4)
Private	oPen		:= TPen():New(0,5,CLR_BLACK)
Private	cFileLogo	:= GetSrvProfString('Startpath','') + 'PXHOL' + '.BMP'
Private	oFont08t	:= TFont():New('Times New Roman',08,08,,.F.,,,,.T.,.F.)

oReport := ReportDef(p_cPergF)
oReport:PrintDialog()

RestArea(wArea)
Return


Static Function ReportDef(p_cPergF)

Local oReport
Local oSection
Local oBreak1

wparam1 := "RELRESCC"  // nome do relatório
wparam2 := "Rel. Resumo por Centro de Custo" //( " + Capital(AllTrim(SM0->M0_CIDCOB))  +" ) "//titulo
wparam3 := p_cPergF
wparam4 := {|oReport| reportPrint(oReport)}
wparam5 := "Este relatorio, mostra a Relação por Centro de Custos."  //descrição

oReport := TReport():New(wparam1,OemToAnsi(wparam2),wparam3,wparam4,OemToAnsi(wparam5))

oReport:SetLandscape()

yparam2 := "Relação por Centro de Custos"//> descrição
yparam3 := {"SZQ" }

oSection1 := TRSection():New(oReport,OemToAnsi(yparam2),yparam3)


Return oReport


Static Function reportPrint(oReport)

LOCAL cFiltro   := ""
LOCAL cQuery    := ""
Local wAliasSec1  := getNextAlias()
Local bPosition
Local oSection1 	:= oReport:Section(1)
Local cFilterUser
Local cFilUserSZQ := oSection1:GetSqlExp()

pergunte(oReport:uparam,.f.)

if empty(mv_par01)  .or. empty(mv_par02)
	Alert('Verificar parametros do relatorio! ')
	Return
Endif

cwhereuser := ''
cwhereuser := "% "+cwhereuser+" %"
nxTam      := 2
nTamValor  := TamSX3("D1_TOTAL")[1]
nTamValor2 := 10
nTamValor3 := 08
cMascara   := PesqPict("SD1","D1_TOTAL")
cMascara2  := "@E 999,999.99"
cMascara3  := "@E 9,999.99"
lLOutPadrao:= len(oReport:Section(1):ACELL) == 0

if lLOutPadrao
	//ntotFields:=  SZQ->( Fcount() )
	
	//for i:=1 to ntotFields
	
	 _aCamp1 := {'ZQ_NOMEMP','ZQ_DTDIGIT','ZQ_EMISSAO','ZQ_ANOMES','ZQ_PREFIXO','ZQ_NUM','ZQ_PARCELA','ZQ_TIPO','ZQ_ESPECIE','ZQ_TOTAL','ZQ_CUSCTB','ZQ_VALLIQ','ZQ_VALDESC','ZQ_FORNECE','ZQ_LOJA','ZQ_NOME','ZQ_OBS','ZQ_CONTA','ZQ_DCONTA','ZQ_YCC','ZQ_DCUSTO','ZQ_ITEMCTA','ZQ_DITEMC','ZQ_PRODUTO','ZQ_DESCRIC','ZQ_CF','ZQ_NATUREZ','ZQ_VENCTO','ZQ_NATSYS','ZQ_COND','ZQ_TES','ZQ_PEDIDO','ZQ_FILIAL','ZQ_TEXTO','ZQ_ITEMPC','ZQ_DUPLIC','ZQ_CODEMP','ZQ_VENCREA','ZQ_BAIXA','ZQ_VALIPI','ZQ_DCLASSV','ZQ_MUN','ZQ_EST','ZQ_VALICM','ZQ_INSS','ZQ_CLVL','ZQ_IRRF','ZQ_VALISS','ZQ_DESPESA','ZQ_SEGURO','ZQ_VRETPIS','ZQ_VRETCOF','ZQ_VRETCSL','ZQ_VCRDPIS','ZQ_VCRDCOF','ZQ_VCRDCSL','ZQ_DESCORI','ZQ_CODVISA','ZQ_DESVISA','ZQ_CODVISS','ZQ_DESVISS','ZQ_CONTVIS'}
       
 		For C := 1 To Len(_aCamp1)	
		
		//cCampo:= szq->(fieldname(i))
		cCampo:=_aCamp1[C]
				
		TRCell():New(oSection1, /*campo*/ cCampo, /*alias*/ 'SZQ' , /*titulo*/ , /*mascara*/ , /*tamanho*/  )
		oSection1:Cell( cCampo ):SetAlign("RIGHT")
		oSection1:Cell( cCampo ):SetHeaderAlign("RIGHT")
		
		
	next
endif

oReport:setTitle("Resumo por Centro de Custo - Ano/Mes: " +mv_par01 +"  a  "+mv_par02 )

MakeSqlExpr(oReport:uparam)


cOrdem:= SqlOrder( szq->( IndexKey() )  )
cOrdem:= "% "+cOrdem+" %"


cOrigem:='' //SE2 ????

if mv_par03 == 1 //Entrada
	cOrigem+=iif(!empty(cOrigem),'/','') + 'SD1'
endif

if mv_par04 == 1 //Mov.Internos
	cOrigem+= iif(!empty(cOrigem),'/','') + 'SD3'
endif

if mv_par05 == 1 //Fol/Ext/Rateio
	cOrigem+= iif(!empty(cOrigem),'/','') + 'FOL/EXT'
endif

if mv_par06 == 1 //Mov.Bancario
	cOrigem+= iif(!empty(cOrigem),'/','') + 'SE5'
endif

cOrigem:= formatIN( alltrim(cOrigem), "/" )
cOrigem:= "% "+cOrigem+" %"

cCampos:=''
nTotCel:= len( oReport:Section(1):ACELL)
for j:=1 to nTotCel
	cCampos+= oReport:Section(1):ACELL[j]:cName + iif( j < nTotCel ,', ', '' )
next

cCampos:= "% "+cCampos+" %"

cwhere:=""

oReport:Section(1):BeginQuery()

BeginSql alias wAliasSec1
	
	select  %Exp:cCampos%
	
	//from %table:SZQ% szq
	//where szq.%notDel%
	//and zq_anomes between %Exp:mv_par01% and %Exp:mv_par02%
	//and zq_orig in %Exp:cOrigem%
	//and zq_emissao between %Exp:mv_par07% and %Exp:mv_par08%
	//and zq_dtdigit between %Exp:mv_par09% and %Exp:mv_par10%
	
	from %table:SZQ% szq
	where szq.%notDel%
	and zq_dtdigit between %Exp:mv_par01% and %Exp:mv_par02%
    and zq_nomemp between %Exp:mv_par03% and %Exp:mv_par04%
	and zq_fornecedor between %Exp:mv_par05% and %Exp:mv_par06%
	and zq_conta between %Exp:mv_par07% and %Exp:mv_par08%
	and zq_ycc between %Exp:mv_par09% and %Exp:mv_par10%
	and zq_tes between %Exp:mv_par11% and %Exp:mv_par12%
	and zq_naturez %Exp:mv_par13% and %Exp:mv_par14%
	and zq_orig in %Exp:cOrigem%
		
	order by %Exp:cOrdem%
	
EndSql

oReport:Section(1):EndQuery()

MemoWrite("c:\RELRESCC.SQL",upper(oReport:Section(1):cQuery))

lTemDados:=Select(wAliasSec1) > 0

if lTemDados
	oReport:SetTotalInLine(.f.)
endif

oReport:Section(1):Print() //IMPRIME TODA SELECAO DA QUERY

Return



Static Function setSX1(cPerg)

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)


// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
AADD(aRegs,{cPerg,"01","Data de Digitacao de          ?","","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Data de Digitacao ate         ?","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Empresa de			          ?","","","mv_ch3","C",05,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","","SM0"})
AADD(aRegs,{cPerg,"04","Empresa ate			          ?","","","mv_ch4","C",05,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","","SM0"})
AADD(aRegs,{cPerg,"05","Fornecedor de       		  ?","","","mv_ch5","C",06,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","","","SA2"})
AADD(aRegs,{cPerg,"06","Fornecedor ate		          ?","","","mv_ch6","C",06,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","","","","SA2"})
AADD(aRegs,{cPerg,"07","Conta de 				      ?","","","mv_ch7","C",11,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","","","","CT1"})
AADD(aRegs,{cPerg,"08","Conta ate         			  ?","","","mv_ch8","C",11,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","","","","CT1"})
AADD(aRegs,{cPerg,"09","Centro de Custo de            ?","","","mv_ch9","C",08,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","","","","","CTT"})
AADD(aRegs,{cPerg,"10","Centro de Custo ate           ?","","","mv_ch10","C",08,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","","","","","CTT"})
AADD(aRegs,{cPerg,"11","Tes de         				  ?","","","mv_ch11","C",03,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","","","","","SF4"})
AADD(aRegs,{cPerg,"12","Tes ate				          ?","","","mv_ch12","C",03,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","","","","","SF4"})
AADD(aRegs,{cPerg,"13","Natureza de			          ?","","","mv_ch13","C",05,0,0,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","","","","","","SED"})
AADD(aRegs,{cPerg,"14","Natureza ate		          ?","","","mv_ch14","C",05,0,0,"G","","mv_par14","","","","","","","","","","","","","","","","","","","","","","","","","","","","","SED"})
//AADD(aRegs,{cPerg,"15","Origem  				      ?","","","mv_ch15","C",06,0,0,"G","","mv_par15","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"15","Consid. Entradas  			  ?","","","mv_ch15","N",01,0,0,"C","","mv_par15","Sim","","","","","Nao","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"16","Consid. Mov.Internos    	  ?","","","mv_ch16","N",01,0,0,"C","","mv_par16","Sim","","","","","Nao","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"17","Consid. Fol/Ext/Rateio  	  ?","","","mv_ch17","N",01,0,0,"C","","mv_par17","Sim","","","","","Nao","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"18","Consid. Mov.Bancario    	  ?","","","mv_ch18","N",01,0,0,"C","","mv_par18","Sim","","","","","Nao","","","","","","","","","","","","","","","","",""})

//AADD(aRegs,{cPerg,"01","Do AnoMes         ?","","","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//AADD(aRegs,{cPerg,"02","Ate AnoMes        ?","","","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//aAdd(aRegs,{cPerg,"03","Consid. Entradas  	  ?","","","mv_ch3","N",01,0,0,"C","","mv_par03","Sim","","","","","Nao","","","","","","","","","","","","","","","","",""})
//aAdd(aRegs,{cPerg,"04","Consid. Mov.Internos    ?","","","mv_ch4","N",01,0,0,"C","","mv_par04","Sim","","","","","Nao","","","","","","","","","","","","","","","","",""})
//aAdd(aRegs,{cPerg,"05","Consid. Fol/Ext/Rateio  ?","","","mv_ch5","N",01,0,0,"C","","mv_par05","Sim","","","","","Nao","","","","","","","","","","","","","","","","",""})
//aAdd(aRegs,{cPerg,"06","Consid. Mov.Bancario    ?","","","mv_ch6","N",01,0,0,"C","","mv_par06","Sim","","","","","Nao","","","","","","","","","","","","","","","","",""})
//AADD(aRegs,{cPerg,"07","Da Emissao          ?","","","mv_ch7","D",08,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//AADD(aRegs,{cPerg,"08","Ate Emissao         ?","","","mv_ch8","D",08,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//AADD(aRegs,{cPerg,"09","Da Entrada          ?","","","mv_ch9","D",08,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//AADD(aRegs,{cPerg,"10","Ate Entrada         ?","","","mv_cha","D",08,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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

dbSelectArea(_sAlias)

Return



static function getUsrFil()
local cret:=''
local warea:= getArea()

pergunte(cpergF,.f.)

dbSelectArea('ZZF')
dbSetOrder(1)

if upper( alltrim( substr( cusuario,7,15 ) ) ) <> 'ADMINISTRADOR'
	
	if !zzf->(dbseek( xfilial('ZZF') +  alltrim(substr(cusuario,7,15)) ))
		alert('Usuario nao cadastrado nos Parametros Usuario X Nivel ')
		return cret
	endif
	
	if empty(zzf->zzf_codemp)
		alert('O campo EMPRESA está vazio nos Parametros Usuario X Nivel ')
		return cret
	endif
	
	if empty(zzf->zzf_codfil)
		alert('O campo FILIAL está vazio nos Parametros Usuario X Nivel ')
		return cret
	endif
endif

cRet+=  ' zq_codemp in '+ formatIN( alltrim(zzf->zzf_codemp), "/" )
cRet+=  ' and zq_codfil in '+ formatIN( alltrim(zzf->zzf_codfil), "/" )

if !empty(zzf->zzf_tes)
	cRet+=  ' and zq_tes not in '+ formatIN( alltrim(zzf->zzf_tes), "/" )
endif
if !empty(zzf->zzf_ccusto)
	cRet+=  ' and zq_ycc in '+ formatIN( alltrim(zzf->zzf_ccusto), "/" )
endif

restArea(warea)

return cRet



static  function frmCadZZF()

local warea:= getArea()

U_cadZZF()

RestArea(warea)

Return .t.