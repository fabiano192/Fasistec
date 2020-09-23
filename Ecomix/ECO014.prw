#include "rwmake.ch"
#Include "PROTHEUS.CH"
#INCLUDE "topconn.ch"

User function ECO014()

Local oDlg5
local aSays		:=	{}
local aButtons 	:= 	{}
local nOpca 	:= 	0
local cCadastro	:= 	"Relação das Saidas de  Mercadoria"

ATUSX1()

Private clog    := ''
Private cPergF  := PadR('ECO014',10)
private ccaminho:= 'c:\'
p_cPergF        := cPergF

lProsseguir:=.f.

AADD(aSays,"Este programa gera um Relatorio com todos os dados de Saida de Mercadoria, para analise gerencial. ")
AADD(aSays,"O relatorio analisa parametros de usario pre-definidos, bem como, os parametros de filtro dinamicos")
AADD(aSays,"     ")
AADD(aSays,"	 " )
AADD(aSays,"Oberve os parametros antes de gerar o arquivo!")
AADD(aSays,"Específico - ECOMIX")
AADD(aButtons, { 5,.T.,{||  Pergunte(cpergF,.t.) } } )	 //Parametro
AADD(aButtons, { 1,.T.,{|o| Processa( {|| RELZZD( nOpca:= 1, cPergF ),"Aguarde..." } )  } } )
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )

Private oReport
Private wArea	:= GetArea()

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

wparam1 := "ECO014"  // nome do relatório
wparam2 := "Rel. Saida de Mercadoria - Geral" //( " + Capital(AllTrim(SM0->M0_CIDCOB))  +" ) "//titulo
wparam3 := p_cPergF
wparam4 := {|oReport| reportPrint(oReport)}
wparam5 := "Este relatorio, mostra a Relação Saida de Mercadoria - Geral."  //descrição
oReport := TReport():New(wparam1,OemToAnsi(wparam2),wparam3,wparam4,OemToAnsi(wparam5))

oReport:SetLandscape()

yparam2   := "Relação Saida de Mercadoria - Geral"//> descrição
yparam3   := {"ZZD"}
oSection1 := TRSection():New(oReport,OemToAnsi(yparam2),yparam3)

Return oReport




Static Function reportPrint(oReport)

LOCAL i,j,nFor
LOCAL cFiltro     := ""
LOCAL cQuery      := ""
Local wAliasSec1  := getNextAlias()
Local bPosition
Local oSection1   := oReport:Section(1)
Local cFilterUser

pergunte(oReport:uparam,.f.)

nxTam     := 2
nTamValor := TamSX3("D1_TOTAL")[1]
nTamValor2:= 10
nTamValor3:= 08
cMascara  := PesqPict("SD1","D1_TOTAL")
cMascara2 := "@E 999,999.99"
cMascara3 := "@E 9,999.99"

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

oReport:setTitle("Relação Saida de Mercadoria - Geral - Periodo: " +DTOC(mv_par01) +"  a  "+DTOC(mv_par02) )

MakeSqlExpr(oReport:uparam)

cOrdem:=  SqlOrder( zzd->( IndexKey() )  )
cOrdem:=  "% "+cOrdem+" %"

cCampos:= ''
nTotCel:= len( oReport:Section(1):ACELL)

for j:=1 to nTotCel
	cCampos+= oReport:Section(1):ACELL[j]:cName + iif( j < nTotCel ,', ', '' )
next

cCampos := "% "+cCampos+" %"
cwhere  := ""

aSelEmp	:= {}

If MV_PAR03 == 1
	aSelEmp:= U_ASSELEMP()
Endif

If !Empty(aSelEmp) .And. MV_PAR03 == 1
	If len(aSelEmp) > 1
		nI := 1
		If ascan(aSelEmp, cEmpAnt) != 0 .and. aSelEmp[nI] !=  cEmpAnt
			aSelEmp[ascan(aSelEmp, cEmpAnt)] := aSelEmp[nI]
			aSelEmp[nI] := cEmpAnt
		EndIf
	EndIf
EndIf

cRetorno1  := ""
nFor       := 0

For nFor := 1 To Len(aSelEmp)
	cRetorno1  += aSelEmp[nFor] + '|'
Next nFor

If Len(aSelEmp) == 0
	Return
Endif

aSelFil	:= {}

If Len(aSelEmp) == 1
	
	If MV_PAR04 == 1
		aSelFil:= U_ASSELFIL()
	Endif
	
	If !Empty(aSelFil) .And. MV_PAR04 == 1
		If len(aSelFil) > 1
			nI := 1
			If ascan(aSelFil, cFilAnt) != 0 .and. aSelFil[nI] !=  cFilAnt
				aSelFil[ascan(aSelFil, cFilAnt)] := aSelFil[nI]
				aSelFil[nI] := cFilAnt
			EndIf
		EndIf
	Else
		Return
	EndIf
	
	cRetornoIn := ""
	nFor       := 0
	
	For nFor := 1 To Len(aSelFil)
		cRetornoIn += aSelFil[nFor] + '|'
	Next nFor
	
Endif

_cFiltro := ""
If Len(aSelEmp) >= 1
	_cFiltro += " ZZD_CODEMP IN " + FormatIn( SubStr( cRetorno1  , 1 , Len( cRetorno1  ) -1 ) , '|' )
Endif

If Len(aSelFil) >= 1
	_cFiltro += " AND ZZD_CODFIL IN " + FormatIn( SubStr( cRetornoIn , 1 , Len( cRetornoIn ) -1 ) , '|' )
Endif

_cFiltro2 := "%"
_cFiltro2 += _cFiltro
_cFiltro2 += "%"

oReport:Section(1):BeginQuery()

BeginSql alias wAliasSec1
	
	select  %Exp:cCampos%
	
	from %table:ZZD% zzd
	where zzd.%notDel%
	and zzd_emis   between %Exp:mv_par01% and %Exp:mv_par02%
	and %Exp:_cFiltro2%
	
	order by %Exp:cOrdem%
	
EndSql

oReport:Section(1):EndQuery()

MemoWrite("c:\temp\ECO014.SQL",upper(oReport:Section(1):cQuery))


lTemDados:=Select(wAliasSec1) >= 0
if lTemDados
	
endif

if lTemDados
	oReport:SetTotalInLine(.f.)
endif

oReport:Section(1):Print() //IMPRIME TODA SELECAO DA QUERY

Return


Static  function frmCadZZF()

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
Endif

U_cadZZF()

restArea(warea)

Return .t.

Static Function AtuSX1()

cPerg := "ECO014"
aRegs := {}

//    	   Grupo/Ordem/Pergunta                /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid          /Var01     /Def01           /defspa1/defeng1/Cnt01/Var02/Def02            /Defspa2/defeng2/Cnt02/Var03/Def03  /defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
U_CRIASX1(cPerg,"01","Emissao De ?            ",""       ,""      ,"mv_ch1","D" ,08     ,0      ,0     ,"G",""            ,"MV_PAR01",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"02","Emissao Ate ?           ",""       ,""      ,"mv_ch2","D" ,08     ,0      ,0     ,"G",""            ,"MV_PAR02",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"03","Seleciona Empresas?     ",""       ,""      ,"mv_ch3","N" ,01     ,0      ,0     ,"C",""            ,"MV_PAR03","Sim"            ,""     ,""     ,""   ,""   ,"Nao"            ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"04","Seleciona Filiais?      ",""       ,""      ,"mv_ch4","N" ,01     ,0      ,0     ,"C",""            ,"MV_PAR04","Sim"            ,""     ,""     ,""   ,""   ,"Nao"            ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")

Return (Nil)
