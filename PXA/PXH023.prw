#include "rwmake.ch"
#Include "PROTHEUS.CH"
#INCLUDE "topconn.ch"

User function PXH023()

Local oDlg5
local aSays		:=	{}
local aButtons 	:= 	{}
local nOpca 	:= 	0
local cCadastro	:= 	"Relação das Saidas de  Mercadoria"
Private clog:=''
Private cPergC:=PadR('RESZZD01_P',10)//PARAMETROS
Private cPergF:=PadR('RESZZD01_F',10)//FILTRO
private ccaminho:= 'c:\'

setSX1(cPergF,'PAR_FILTRO' )

lProsseguir:=.f.


AADD(aSays,"Este programa gera um Relatorio com todos os dados de Saida de Mercadoria, para analise gerencial. ")
AADD(aSays,"O relatorio analisa parametros de usario pre-definidos, bem como, os parametros de filtro dinamicos")
AADD(aSays,"     ")
AADD(aSays,"	 " )
AADD(aSays,"Oberve os parametros antes de gerar o arquivo!")
AADD(aSays,"Específico - PXHOL")
AADD(aButtons, {17,.T.,{||  pergunte(cpergF,.t.) } } )	 //filtro
AADD(aButtons, { 1,.T.,{|o| Processa( {|| RELZZD( nOpca:= 1, cPergF ),"Aguarde..." } )  } } )
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )


formBatch( cCadastro, aSays, aButtons ,,450  ,550 )

Return



Static Function RELZZD(p_nOpcao, p_cPergF)

Local oReport
Local wArea	:= GetArea()

Private	oBrush		:= TBrush():New(,4)
Private	oPen		:= TPen():New(0,5,CLR_BLACK)
Private	cFileLogo	:= GetSrvProfString('Startpath','') + 'ARICA' + '.BMP'
Private	oFont08t	:= TFont():New('Times New Roman',08,08,,.F.,,,,.T.,.F.)

oReport := ReportDef(p_cPergF)
oReport:PrintDialog()

RestArea(wArea)
Return


Static Function ReportDef(p_cPergF)
Local oReport
Local oSection
Local oBreak1

wparam1 := "PXH023"  // nome do relatório
wparam2 := "Rel. Saida de Mercadoria - Geral" //( " + Capital(AllTrim(SM0->M0_CIDCOB))  +" ) "//titulo

wparam3 := p_cPergF

wparam4 := {|oReport| reportPrint(oReport)}

wparam5 := "Este relatorio, mostra a Relação Saida de Mercadoria - Geral."  //descrição

oReport := TReport():New(wparam1,OemToAnsi(wparam2),wparam3,wparam4,OemToAnsi(wparam5))

oReport:SetLandscape()

yparam2 := "Relação Saida de Mercadoria - Geral"//> descrição
yparam3 := {"ZZD" }

oSection1 := TRSection():New(oReport,OemToAnsi(yparam2),yparam3)


Return oReport




Static Function reportPrint(oReport)

LOCAL cFiltro   := ""
LOCAL cQuery    := ""
Local wAliasSec1  := getNextAlias()
Local bPosition
Local oSection1 	:= oReport:Section(1)
Local cFilterUser

pergunte(oReport:uparam,.f.)

if empty(mv_par01)  .or. empty(mv_par02)
	Alert('Verificar parametros do relatorio! ')
	Return
Endif

nxTam:=2
nTamValor :=TamSX3("D1_TOTAL")[1]
nTamValor2:=10
nTamValor3:=08

cMascara := PesqPict("SD1","D1_TOTAL")
cMascara2:= "@E 999,999.99"
cMascara3:= "@E 9,999.99"

lLOutPadrao:= len(oReport:Section(1):ACELL) == 0

if lLOutPadrao
	ntotFields:=  zzd->( Fcount() )
	
	for i:=1 to ntotFields
		
		cCampo:= zzd->(fieldname(i))
		
		TRCell():New(oSection1, /*campo*/ cCampo, /*alias*/ 'ZZD' , /*titulo*/ , /*mascara*/ , /*tamanho*/  )
		oSection1:Cell( cCampo ):SetAlign("RIGHT")
		oSection1:Cell( cCampo ):SetHeaderAlign("RIGHT")
		
	next
endif

oReport:setTitle("Relação Saida de Mercadoria - Geral - Ano/Mes: " +mv_par01 +"  a  "+mv_par02 )

#IFDEF TOP
	
	MakeSqlExpr(oReport:uparam)
	
	
	cOrdem:= SqlOrder( zzd->( IndexKey() )  )
	cOrdem:= "% "+cOrdem+" %"
	
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
		
		from %table:ZZD% zzd
		where zzd.%notDel%
		and zzd_anomes between %Exp:mv_par01% and %Exp:mv_par02%
		and zzd_clie between %Exp:mv_par03% and %Exp:mv_par04%
		and zzd_loja between %Exp:mv_par05% and %Exp:mv_par06%
		and zzd_emis between %Exp:mv_par07% and %Exp:mv_par08%
		and zzd_codfil between %Exp:mv_par09% and %Exp:mv_par10%
		
		order by %Exp:cOrdem%
				
	EndSql
		
	oReport:Section(1):EndQuery()
	
	MemoWrite("c:\PXH023.SQL",upper(oReport:Section(1):cQuery))
	
	
	lTemDados:=Select(wAliasSec1) >= 0
	if lTemDados
		
	endif
	
#ELSE
	
#ENDIF

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
AADD(aRegs,{cPerg,"01","Do AnoMes         ?","","","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Ate AnoMes        ?","","","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Do Cliente          ?","","","mv_ch5","C",06,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Ate Cliente         ?","","","mv_ch6","C",06,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"05","Da Loja             ?","","","mv_ch7","C",02,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"06","Ate Loja            ?","","","mv_ch8","C",02,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"07","Da Emissao          ?","","","mv_ch7","D",08,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"08","Ate Emissao         ?","","","mv_ch8","D",08,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"09","Da Filial           ?","","","mv_ch9","C",06,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"10","Ate Filial          ?","","","mv_cha","C",06,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})


For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
				
				Do Case
					Case aRegs[i,2]$'05/06' //CLIENTE
						SX1->X1_F3 := 'SA1'
					Case aRegs[i,2]$'15' //CLIENTE
						//SX1->X1_F3 := 'SA6'
				EndCase
				
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

dbSelectArea('ZZF')
dbSetOrder(1)

If upper( alltrim( substr( cusuario,7,15 ) ) ) <> 'ADMINISTRADOR'
	
	if !zzf->(dbseek( xfilial('ZZF') +  alltrim(substr(cusuario,7,15)) ))
		alert('Usuario nao cadastrado nos Parametros Usuario X Nivel ')
		return .f.
	endif
	
	if val(zzf->zzf_nivel) < 6
		alert('Usuario sem permissao!')
		return .t.
	endif
endif

u_cadZZF()

restArea(warea)

Return .t.                               