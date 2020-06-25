#INCLUDE "MATA116.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"

#DEFINE ROTINA 		01 // Define a Rotina : 1-Inclusao / 2-Exclusao
#DEFINE TIPONF		02 // Considerar Notas : 1 - Compra , 2 - Devolucao
#DEFINE DATAINI		03 // Data Inicial para Filtro das NF Originais
#DEFINE DATAATE		04 // Data Final para Filtro das NF originais
#DEFINE FORNORI		05 // Cod. Fornecedor para Filtro das NF Originais
#DEFINE LOJAORI		06 // Loja Fornecedor para Fltro das NF Originais
#DEFINE FORMUL		07 // Utiliza Formulario proprio ? 1-Sim,2-Nao
#DEFINE NUMNF		08 // Num. da NF de Conhecimento de Frete
#DEFINE SERNF		09 // Serie da NF de COnhecimento de Frete
#DEFINE FORNECE		10 // Codigo do Fornecedor da NF de FRETE
#DEFINE LOJA		11 // Loja do Fornecedor da NF de Frete
#DEFINE TES			12 // Tes utilizada na Classificacao da NF
#DEFINE VALOR		13 // Valor total do Frete sem Impostos
#DEFINE UFORIGEM	14 // Estado de Origem do Frete
#DEFINE AGLUTINA	15 // Aglutina Produtos : .T. , .F.
#DEFINE BSICMRET	16 // Base do Icms Retido
#DEFINE VLICMRET	17 // Valor do Icms Retido
#DEFINE FILTRONF    18 // Filtra nota com conhecimento frete .F. , .T.
#DEFINE ESPECIE	    19 // Especie da Nota Fiscal

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ VN0008   ³ Autor ³ Alexandro da Silva     ³ Data ³28/02/2016³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa de Digitacao de Conhecimento de Frete              ³±±
±±³          ³ Utiliza a funcao MATA103 p/ gerar a Nota Fiscal de Entrada  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function VN0008()

Local lInclui := .T.
LOCAL aIndexSF1 	:= {}
LOCAL cFiltraSF1 	:= ""
LOCAL cQrySF1    	:= ""
LOCAL cRetPE 	 	:= ""
LOCAL cNFExc		:= ""
LOCAL cSerieExc		:= ""
LOCAL cFornExc		:= ""
LOCAL cLojaExc		:= ""
LOCAL lContinua  	:= .T.
LOCAL aBkpRotina	:={}
&("M->F1_CHVNFE") := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Array contendo as Rotinas a executar do programa      ³
//³ ----------- Elementos contidos por dimensao ------------     ³
//³ 1. Nome a aparecer no cabecalho                              ³
//³ 2. Nome da Rotina associada                                  ³
//³ 3. Usado pela rotina                                         ³
//³ 4. Tipo de Transa‡„o a ser efetuada                          ³
//³    1 - Pesquisa e Posiciona em um Banco de Dados             ³
//³    2 - Simplesmente Mostra os Campos                         ³
//³    3 - Inclui registros no Bancos de Dados                   ³
//³    4 - Altera o registro corrente                            ³
//³    5 - Remove o registro corrente do Banco de Dados          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private bFiltraBrw  := {|| Nil}
Private cCadastro   := "Nota Fiscal de Conhecimento de Frete"

Private aParametros := {}
Private aRotina     := {}
Private INCLUI      := .F.
Private ALTERA      := .F.
Private aBackSDE    := {}
Private aNFEDanfe   := {}
Private aDanfeComp  := {}
Private dEmisOld    := ""
Private cCA100ForOld:= ""
Private cCondicaoOld:= ""
Private cEspecie2	:= ""
Private aUsButtons 	:= {}
Private nRotina 	:= 0
Private cChvNFE     := ""
Private cTPCTE      := ""

aRotina := MenuDef()

If lContinua
	If !A116Setup(@aParametros)
		lContinua := .F.
	EndIf
EndIf

If lContinua
	
	dDataIni	   := aParametros[DATAINI]
	dDataFim	   := aParametros[DATAATE]
	nRotina        := aParametros[ROTINA]
	cFornOri	   := aParametros[FORNORI]
	cLojaOri	   := aParametros[LOJAORI]
	nTipoOri	   := aParametros[TIPONF]
	lAglutProd     := aParametros[AGLUTINA]
	cUFOri		   := aParametros[UFORIGEM]
	lFiltroNF      := aParametros[FILTRONF]
	cEspecie2	   := aParametros[ESPECIE]
	aRotina := MenuDef()
	
	aBkpRotina := Aclone(aRotina)
	
	dbSelectArea("SF2")
	dbSetOrder(1)
	
	cFiltraSF1	:= 'F2_FILIAL=="'+xFilial("SF2")+'".And.'
	cQrySF1     := "F2_FILIAL='"+xFilial("SF2")+"' AND "
	If !Empty(cFornOri).And.!Empty(cLojaOri)
		cFiltraSF1	+= ' F2_CLIENTE=="'+cFornOri+'".And.F2_LOJA=="'+cLojaOri+'" .And. '
		cQrySF1     += " F2_CLIENTE='"+cFornOri+"' AND F2_LOJA = '"+cLojaOri+"' AND "
	Endif
	cFiltraSF1 += 'DTOS(F2_EMISSAO)>="'+DTOS(dDataIni)+'".And.DTOS(F2_EMISSAO)<="'+DTOS(dDataFim)+'".And.'
	cQrySF1    += "F2_EMISSAO>='"+DTOS(dDataIni)+"' AND F2_EMISSAO <= '"+DTOS(dDataFim)+"' AND "
	
	cFiltraSF1	+= 'F2_TIPO$"'+If(nTipoOri==1,"N","BD")+'"'
	If nTipoOri == 1
		cQrySF1 += "F2_TIPO = 'N' "
	Else
		cQrySF1 += "F2_TIPO IN('B','D') "
	EndIf
	bFiltraBrw 	:= {|x| IIf(x==Nil,FilBrowse("SF2",@aIndexSF1,@cFiltraSF1),cQrySF1)}
	
	If !InTransact()
		Eval(bFiltraBrw)
	EndIf
	
	dbSelectArea("SF2")
	If BOF() .And. EOF()
		HELP(" ",1,"RECNO")
	Else
		If nRotina == 1
			mBrowse( 6, 1,22,75,"SF2")
		Else
			MarkBrow("SF2","F2_OK","",,,,,,,,"a116Mark()")
		EndIf
	EndIf
	
	//If !Intransact()
	//	EndFilBrw("SF2",aIndexSF1)
	//	RetIndex("SF2")
	//EndIf
Else
	lInclui := .F.
EndIf

SF2->(dbSetOrder(1))

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A116Setup³ Autor ³ Edson Maricate         ³ Data ³17.11.2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Faz a montagem da tela de parametros do MATA116.            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpA1 : [1] Define a Rotina : 1-Inclusao / 2-Exclusao       ³±±
±±³          ³        [2] Considerar Notas : 1 - Compra , 2 - Devolucao   ³±±
±±³          ³        [3] Data Inicial para Filtro das NF Originais       ³±±
±±³          ³        [4] Data Final para Filtro das NF originais         ³±±
±±³          ³        [5] Cod. Fornecedor para Filtro das NF Originais    ³±±
±±³          ³        [6] Loja Fornecedor para Fltro das NF Originais     ³±±
±±³          ³        [7] Utiliza Formulario proprio ? 1-Sim,2-Nao        ³±±
±±³          ³        [8] Num. da NF de Conhecimento de Frete             ³±±
±±³          ³        [9] Serie da NF de COnhecimento de Frete            ³±±
±±³          ³        [10]Codigo do Fornecedor da NF de FRETE             ³±±
±±³          ³        [11]Loja do Fornecedor da NF de Frete               ³±±
±±³          ³        [12]Tes utilizada na Classificacao da NF            ³±±
±±³          ³        [13]Valor total do Frete sem Impostos               ³±±
±±³          ³        [14]Estado de Origem do Frete                       ³±±
±±³          ³        [15]Aglutina Produtos : .T. , .F.                   ³±±
±±³          ³        [16]Base do Icms Retido                             ³±±
±±³          ³        [17]Valor do Icms Retido                            ³±±
±±³          ³        [18]Filtra nota com conhecimento frete 1-Nao , 2-Sim³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MATA116,SIGACOM,SIGAEST                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function A116Setup(aParametros)

Local aCombo1	    := {STR0006,STR0007} //"Incluir NF de Conhec. Frete"###"Excluir NF de Conhec. Frete"
Local aCombo2	    := {"NF Normal"}//,STR0009} //"NF Normal"###"NF Devol./Benef."
Local aCombo3	    := {STR0010,STR0011} //"NÃo"###"Sim"
Local aCombo4	    := {STR0011,STR0010} //"Sim"###"NÃo"
Local aCombo5	    := {STR0010,STR0011} //"NÃo"###"Sim"
//Local aCliFor	    := {{STR0013,"SA1"}}//{{STR0012,"FOR"},{STR0013,"SA1"}} //"Fornecedor"###"Cliente" 
Local aCliFor	    := {{STR0012,"FOR"},{STR0013,"SA1"}} //"Fornecedor"###"Cliente"
Local nCombo1	    := 2
Local nCombo2	    := 1
Local nCombo3	    := 1
Local nCombo4	    := 1
Local nCombo5	    := 1
Local n116Valor	    := 0
Local n116BsIcmret	:= 0
Local n116VlrIcmRet	:= 0
Local nOpcAuto      := 1  //1= Exclusao - 2= Inclusao
Local nX            := 0
Local d116DataDe    := dDataBase - 90
Local d116DataAte   := dDataBase
LocaL lMT116VTP:= .F.

Local c116Combo1    := aCombo1[nCombo1]
Local c116Combo2    := aCombo2[1]
Local c116Combo3    := aCombo3[1]
Local c116Combo4	:= aCombo4[1]
Local c116Combo5    := aCombo5[1]
Local c116FornOri   := CriaVar("F2_CLIENTE",.F.)
Local c116LojaOri   := CriaVar("F2_LOJA",.F.)
Local c116NumNF	    := CriaVar("F2_DOC",.F.)
Local c116SerNF	    := CriaVar("F2_SERIE",.F.)
Local c116Fornece   := CriaVar("F2_CLIENTE",.F.)
Local c116Loja	    := CriaVar("F2_LOJA",.F.)
Local c116Tes	    := CriaVar("D2_TES",.F.)
Local lRet		    := .F.

Local oDlg
Local oCombo1
Local oCombo2
Local oCombo3
Local oCombo4
Local oCombo5
Local oCliFor
Local oFornOri

Private c116UFOri	  := CriaVar("A2_EST",.F.)
Private aValidGet	  := {}
Private c116Especie   := CriaVar("F1_ESPECIE",.F.)

DEFINE MSDIALOG oDlg FROM 87 ,52  TO 500/*450*/,609 TITLE STR0014+cCadastro Of oMainWnd PIXEL //"Parametros "
@ 22 ,3   TO 68 ,274 LABEL STR0022 OF oDlg PIXEL //"Parametros do Filtro"
@ 6 ,48  MSCOMBOBOX oCombo1 VAR c116Combo1 ITEMS aCombo1 SIZE 83 ,50 OF oDlg PIXEL VALID (nCombo1:=aScan(aCombo1,c116Combo1))
@ 7  ,6   SAY STR0024 Of oDlg PIXEL SIZE 43,09 //"Quanto a Nota"
@ 7  ,140 SAY STR0025 Of oDlg PIXEL SIZE 100 ,9 //"Filtrar notas com conhecimento de frete"
@ 7  ,245 MSCOMBOBOX oCombo5 VAR c116Combo5 ITEMS aCombo5 SIZE 30 ,50 OF oDlg PIXEL When (nCombo1==1) VALID (nCombo5:=aScan(aCombo5,c116Combo5))
@ 34 ,12  SAY STR0026 Of oDlg PIXEL SIZE 60 ,9 //"Data Inicial"
@ 34 ,125 SAY STR0027 Of oDlg PIXEL SIZE 59 ,9 //"Data Final"
@ 33 ,48  MSGET d116DataDe  Valid !Empty(d116DataDe) OF oDlg PIXEL SIZE 60 ,9
@ 33 ,165 MSGET d116DataAte Valid !Empty(d116DataAte) OF oDlg PIXEL SIZE 60 ,9

@ 52  ,12 SAY STR0028 Of oDlg PIXEL SIZE 54 ,9 //"Considerar"
//@ 51  ,48 MSCOMBOBOX oCombo2 VAR c116Combo2 ITEMS aCombo2 SIZE 60 ,50 OF oDlg PIXEL When (nCombo1==1) VALID ((nCombo2:=aScan(aCombo2,c116Combo2)),oCliFor:Refresh(),oFornOri:cF3:=aCliFor[nCombo2][2],c116FornOri:=SPACE(Len(c116FornOri)),c116LojaOri:=SPACE(Len(c116LojaOri)))
@ 51  ,48 MSCOMBOBOX oCombo2 VAR c116Combo2 ITEMS aCombo2 SIZE 60 ,50 OF oDlg PIXEL When (nCombo1==1) VALID ((nCombo2:=aScan(aCombo2,c116Combo2)),oCliFor:Refresh(),oFornOri:cF3:=aCliFor[2][2],c116FornOri:=SPACE(Len(c116FornOri)),c116LojaOri:=SPACE(Len(c116LojaOri)))

@ 52 ,125 SAY oCliFor VAR aCliFor[2][1] Of oDlg PIXEL SIZE 28 ,9
@ 51 ,165 MSGET oFornOri VAR c116FornOri Picture PesqPict("SA1","A1_COD") F3 aCliFor[2][2] OF oDlg PIXEL SIZE 80 ,9 VALID Empty(c116FornOri).Or.A116StpVld(nCombo2,c116FornOri,@c116LojaOri,,1)
@ 51 ,245 MSGET c116LojaOri Picture PesqPict("SA1","A1_LOJA") F3 CpoRetF3("A1_LOJA")OF oDlg PIXEL SIZE 19 ,9 VALID Empty(c116LojaOri).Or.A116StpVld(nCombo2,c116FornOri,c116LojaOri,,1)

@ 74 ,3   TO 180,274 LABEL STR0029 OF oDlg PIXEL //"Dados da NF de Frete"
@ 86 ,10  SAY STR0030 Of oDlg PIXEL SIZE 32 ,9 COLOR CLR_HBLUE,oDlg:nClrPane //"Form. Proprio"
@ 85 ,47  MSCOMBOBOX oCombo3 VAR c116Combo3 ITEMS aCombo3 SIZE 35 ,50 OF oDlg PIXEL When (nCombo1==1) VALID ((nCombo3:=aScan(aCombo3,c116Combo3)),c116NumNF:=SPACE(Len(c116NumNF)),c116SerNF:=SPACE(Len(c116SerNF)))

@ 86 ,125 SAY STR0031 Of oDlg PIXEL SIZE 39 ,9 COLOR CLR_HBLUE,oDlg:nClrPane //"Num. Conhec."
@ 85 ,165 MSGET c116NumNF Picture PesqPict("SF1","F1_DOC") OF oDlg PIXEL SIZE 50 ,9 When (nCombo1==1.And.nCombo3==1) VALID A116NCF(@c116NumNF).And.A116ChkNFE(nCombo3,c116Fornece,c116Loja,c116NumNF,c116SerNF)

@ 86 ,225 SAY STR0047 Of oDlg PIXEL SIZE 15 ,9  //"Serie"
@ 85 ,242 MSGET c116SerNF Picture PesqPict("SF1","F1_SERIE") OF oDlg PIXEL SIZE 19 ,9  When (nCombo1==1.And.nCombo3==1) VALID A116ChkNFE(nCombo3,c116Fornece,c116Loja,c116NumNF,c116SerNF)

@ 105,10  SAY STR0012 Of oDlg PIXEL SIZE 47 ,9 COLOR CLR_HBLUE,oDlg:nClrPane //"Fornecedor"
@ 104,47  MSGET c116Fornece  Picture PesqPict("SF1","F1_FORNECE") F3 aCliFor[1][2] OF oDlg PIXEL SIZE 80 ,9 When (nCombo1==1) VALID A116StpVld(1,c116Fornece,@c116Loja,@c116UfOri,2).And.A116ChkNFE(nCombo3,c116Fornece,c116Loja,c116NumNF,c116SerNF)
@ 104,128 MSGET c116Loja Picture PesqPict("SF1","F1_LOJA") F3 CpoRetF3("F1_LOJA") OF oDlg PIXEL SIZE 19 ,9 When (nCombo1==1) VALID A116StpVld(1,c116Fornece,c116Loja,@c116UfOri,2).And.A116ChkNFE(nCombo3,c116Fornece,c116Loja,c116NumNF,c116SerNF)

@ 105,152 SAY STR0032 Of oDlg PIXEL SIZE 32 ,9 COLOR CLR_HBLUE,oDlg:nClrPane //"Cod. TES"
@ 104,175 MSGET c116TES Picture PesqPict("SD1","D1_TES") F3 CpoRetF3("D1_TES");
OF oDlg PIXEL SIZE 25 ,9 When (nCombo1==1) VALID  (Empty(c116Tes) .Or. ExistCpo("SF4",c116Tes)) .And. A116ChkTES(c116TES)

@ 105,205 SAY STR0046 Of oDlg PIXEL SIZE 33 ,9 COLOR CLR_HBLUE,oDlg:nClrPane //" Valor"
@ 104,220 MSGET n116Valor Picture PesqPict("SD1","D1_TOTAL") ;
OF oDlg PIXEL SIZE 51 ,9 When (nCombo1==1)

@ 125,10  SAY STR0033 Of oDlg PIXEL SIZE 36 ,9 //"UF Origem"
@ 124,47  MSGET c116UfOri Picture PesqPict("SA2","A2_EST") F3 CpoRetF3("A2_EST");
OF oDlg PIXEL SIZE 25 ,9 	When (nCombo1==1) VALID Vazio(c116UFOri) .Or. ExistCPO("SX5","12"+c116UFOri)

@ 125,120 SAY STR0034 Of oDlg PIXEL SIZE 48 ,9 //"Aglutina Produtos ?"
@ 125,180 MSCOMBOBOX oCombo4 VAR c116Combo4 ITEMS aCombo4 SIZE 30 ,50 OF oDlg PIXEL When (nCombo1==1) VALID (nCombo4:=aScan(aCombo4,c116Combo4))

@ 146,10  SAY STR0035 Of oDlg PIXEL SIZE 49 ,9 //"Bs Icms Ret."
@ 144,47  MSGET oGetBs VAR n116BsIcmRet  Picture PesqPict("SD1","D1_BRICMS") F3 CpoRetF3("D1_BRICMS");
OF oDlg PIXEL SIZE 70 ,9 When (nCombo1==1) VALID Positivo(n116BsIcmRet)

@ 144,140 SAY STR0036 Of oDlg PIXEL SIZE 41 ,9 //"Vlr. Icms Ret."
@ 143,180 MSGET n116VlrIcmRet Picture PesqPict("SD1","D1_ICMSRET") F3 CpoRetF3("D1_ICMSRET");
OF oDlg PIXEL SIZE 70 ,9 When (nCombo1==1) VALID Positivo(n116VlrIcmRet)

@ 166,10  SAY "Especie:" Of oDlg PIXEL SIZE 49 ,9 //"Bs Icms Ret."
@ 164,47  MSGET oGetBs VAR c116Especie  Picture PesqPict("SF1","F1_ESPECIE") F3 CpoRetF3("F1_ESPECIE");
OF oDlg PIXEL SIZE 25 ,9 When (nCombo1==1) VALID CheckSX3("F1_ESPECIE",c116Especie)

@188,220 BUTTON STR0037 SIZE 35 ,10  FONT oDlg:oFont ACTION If(A116StpOk(c116NumNF,c116Fornece,c116Loja,c116Tes,c116FornOri,c116LojaOri,nCombo1,n116Valor,nCombo3),(lRet:=.T.,oDlg:End()),Nil)  OF oDlg PIXEL //"Confirma >>"
@188,180 BUTTON STR0038 SIZE 35 ,10  FONT oDlg:oFont ACTION (oDlg:End())  OF oDlg PIXEL //"<< Cancelar"

ACTIVATE MSDIALOG oDlg CENTERED
nCombo1:= If(nCombo1==1,2,1)

aParametros:= {	nCombo1,; // 1 Define a Rotina : 1-Inclusao / 2-Exclusao
nCombo2,; 		      // 2 Considerar Notas : 1 - Compra , 2 - Devolucao
d116DataDe,; 		  // 3 Data Inicial para Filtro das NF Originais
d116DataAte,;		  // 4 Data Final para Filtro das NF originais
c116FornOri,;		  // 5 Cod. Fornecedor para Filtro das NF Originais
c116LojaOri,;		  // 6 Loja Fornecedor para Fltro das NF Originais
nCombo3,; 			  // 7 Utiliza Formulario proprio ? 1-Sim,2-Nao
c116NumNF,;  		  // 8 Num. da NF de Conhecimento de Frete
c116SerNF,;  		  // 9 Serie da NF de COnhecimento de Frete
c116Fornece,;		  // 10 Codigo do Fornecedor da NF de FRETE
c116Loja,;   		  // 11 Loja do Fornecedor da NF de Frete
c116Tes,;    		  // 12 Tes utilizada na Classificacao da NF
n116Valor,;  		  // 13 Valor total do Frete sem Impostos
c116UFOri,;  		  // 14 Estado de Origem do Frete
(nCombo4==1),; 		  // 15 Aglutina Produtos : .T. , .F.
n116BsIcmRet,;	      // 16 Base do Icms Retido
n116VlrIcmRet,;		  //17 Valor do Icms Retido
(nCombo5==2),;  	  //18 Filtra nota com conhecimento frete .F. , .T.
c116Especie,;		  //19 Especie da Nota Fiscal
}

Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A116StpVl³ Autor ³ Edson Maricate         ³ Data ³17.11.2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Valida o codigo do fornecedor/cliente digitado.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpN1: Tipo de conhecimento de Frete     	                  ³±±
±±³          ³       1 - Cliente                        	              ³±±
±±³          ³       2 - Fornecedor                                       ³±±
±±³          ³ExpC2: Codigo do cliente/fornecedor                         ³±±
±±³          ³ExpC3: Loja do cliente/fornecedor                           ³±±
±±³          ³ExpC4: Uf de Origem				                          ³±±
±±³          ³ExpC5: Origem.     				                          ³±±
±±³          ³       1 - Cliente/Fornecedor do Filtro	                  ³±±
±±³          ³       2 - Cliente/Fornecedor do Documento de Frete         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL: Validacao do fornecedor/cliente                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MATA116                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function A116StpVld(nTipo,cCodigo,cCodLoja,c116UfOri,cOrigem)

Local aArea		:= GetArea()
Local aAreaSA1	:= SA1->(GetArea())
Local aAreaSA2	:= SA2->(GetArea())
Local lRet		:= .F.

If !Empty(cCodigo)
	
	dbSelectArea("SA1")
	If !Empty(cCodigo)
		If cCodLoja == Nil .Or. Empty(cCodLoja)
			SA1->(dbSetOrder(1))
			SA1->(MsSeek(xFilial("SA1")+cCodigo))
			If SA1->(Found())
				lRet := .T.
				cCodLoja := SA1->A1_LOJA
			Else
				HELP("  ",1,"REGNOIS")
			EndIf
		Else
			SA1->(dbSetOrder(1))
			SA1->(MsSeek(xFilial("SA1")+cCodigo+cCodLoja))
			If SA1->(Found())
				lRet := .T.
			Else
				HELP("  ",1,"REGNOIS")
			EndIf
		EndIf
		
		If lRet .And. cOrigem == 2
			If !RegistroOk("SA1")
				lRet := .F.
			EndIf
		EndIf
	EndIf
Else
	lRet := .T.
EndIf

RestArea(aAreaSA1)
RestArea(aAreaSA2)
RestArea(aArea)

Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A116ChkNFE³ Autor ³ Edson Maricate        ³ Data ³07.01.2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Verifica se a NF ja existe ou esta sendo incluida em outra  ³±±
±±³          ³estacao .                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpN1: Informe 1 para consistir o documento de entrada      ³±±
±±³          ³ExpC2: Codigo do fornecedor                                 ³±±
±±³          ³ExpC3: Loja do fornecedor                                   ³±±
±±³          ³ExpC4: Numero do documento de entrada                       ³±±
±±³          ³ExpC5: Serie dodocumento de entrada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL: Validacao do documento de entrada                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MATA116                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function A116ChkNFE(nFormul,cFornece,cCodLoja,cNFiscal,cSerie)

Local lRet      := .T.
Local lMT116Vld := .T.

If !Empty(cFornece) .And. !Empty(cCodLoja)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste duplicidade de digitacao de Nota Fiscal  			        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nFormul == 1
		SF2->(dbSetOrder(1))
		If SF2->(MsSeek(xFilial("SF2")+cNFiscal+cSerie+cFornece+cCodLoja,.F.))
			HELP(" ",1,"EXISTNF")
			lRet := .F.
		EndIf
	EndIf
EndIf

Return (lRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A116NCF   ³ Autor ³ Julio C Guerato       ³ Data ³19.01.2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao que aplica ponto de entrada para manipular numero da ³±±
±±³          ³nf de conhecimento                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Numero do documento de entrada                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL:  Retornar o valor manipulado do Doc.Entrada           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MATA116                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function A116NCF(c116NumNF)

Local lRet := .T.
Local cPEcNFiscal := ""

Return (lRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A116StpVld³ Autor ³ Edson Maricate        ³ Data ³07.01.2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Verifica os dados do formulario de selecao do conhecimento  ³±±
±±³          ³de frete.                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Documento de Saida                                   ³±±
±±³          ³ExpC2: Codigo do fornecedor                                 ³±±
±±³          ³ExpC3: Loja do fornecedor                                   ³±±
±±³          ³ExpC4: TES                                                  ³±±
±±³          ³ExpC5: Fornecedor de Origem                                 ³±±
±±³          ³ExpC6: Loja do fornecedor de origem                         ³±±
±±³          ³ExpN7: Indica se valida o conhecimento de frete             ³±±
±±³          ³ExpN8: Valor do conhecimento de frete                       ³±±
±±³          ³ExpN9: Indica se valida o numero do conhecimento de frete   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL: Validacao do documento de entrada                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MATA116                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function A116StpOk(cNumNF,cFornece,cLoja,cTes,cFornOri,cLojaOri,nCombo1,nValor,nCombo3)

Local lRet := .T.

If nCombo1 == 1
	If (Empty(cNumNF).And.nCombo3==1) .Or. Empty(cFornece) .Or. Empty(cLoja) .Or. Empty(cTes) .Or. Empty(nValor)
		Aviso(STR0039,STR0040,{STR0041},2) //"Atencao!"###"Existem campos de preenchimento obrigatorio que nao foram informados. Verifique os campos da tela de que contem os dados da nota fiscal."###"Voltar"
		lRet := .F.
	EndIf
EndIf

If lRet .And. (!Empty(cFornOri).And.Empty(cLojaOri))
	Aviso(STR0039,STR0042,{STR0041},2) //"Atencao!"###"Codigo da loja do fornecedor invalida. Verifique o preenchimento correto da loja do Fornecedor nos parametros para filtragem da nota fiscal."###"Voltar"
	lRet := .F.
EndIf

Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A116Inclui³ Autor ³ Edson Maricate        ³ Data ³27/03/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Alias de entrada                                     ³±±
±±³          ³ExpC2: Campo com a marca da Markbrowse                      ³±±
±±³          ³ExpC3: Opcao do arotina                                     ³±±
±±³          ³ExpC4: Codigo da marca                                      ³±±
±±³          ³ExpC5: Indicador de inversao de marca                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³MATA116                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static FUNCTION A116Inclui(cAlias,cCampo,nOpcX,cMarca,lInverte)

Local lContinua	 := .T.
Local l116Inclui := .F.
Local l116Exclui := .F.
Local l116Visual := .F.
Local lDigita    := .F.
Local lAglutina  := .F.
Local lGeraLanc  := .F.
Local lQuery     := .F.
Local lSkip      := .F.
Local lAviso     := .T.
Local lM116ACOL  := ExistBlock("M116ACOL")

Local bCabOk     := {|| .T.}
Local bIPRefresh:= {|| MaFisToCols(aHeader,aCols,,"MT100"),Eval(bRefresh),Eval(bGdRefresh)}	// Carrega os valores da Funcao fiscal e executa o Refresh

Local aCpos2	 := {"D1_VUNIT","D1_TOTAL","D1_PICM","D1_IPI","D1_CONTA","D1_CC","D1_VALICM","D1_CF","D1_TES","D1_BASEICM","D1_BASEIPI","D1_VALIPI","D1_ITEMCTA","D1_CLVL","D1_CLASFIS","D1_BASEINS","D1_ALIQINS","D1_VALINS","D1_OPER"}
Local aInfForn	 := {"","",CTOD("  /  /  "),CTOD("  /  /  "),"","","",""}
Local aValores	 := {0,0,0,0,0,0,0,0,0}
Local aTitles	 := {STR0015,; //"Totais"
STR0016,; //"Inf. Fornecedor/Cliente"
STR0017,; //"Descontos/Frete/Despesas"
STR0018,; //"Livros Fiscais"
STR0019,; //"Impostos"
STR0020}  //"Duplicatas"
Local aButtons	 := { {"S4WB013N",{||NfeRatCC(aHeadSDE,aColsSDE,l116Inclui)},STR0043,STR0044} } //"Rateio por Centro de Custo"
Local aFldCBAtu  := Array(Len(aTitles))
Local aSizeAut	 := MsAdvSize(,.F.,400)
Local aAuxRefSD1 := MaFisSXRef("SD1")
Local aHeadSE2   := {}
Local aHeadSEV   := {}
Local aHeadSDE	 := {}
Local aColsSDE   := {}
Local aColsSE2   := {}
Local aColsSEV   := {}
Local aRecSD1	 := {}
Local aRecSE2	 := {}
Local aRecSF3	 := {}
Local aRecSC5	 := {}
Local aRecSF8	 := {}
Local aRecSDE	 := {}
Local aRecSF1Ori := {}
Local aObjects	 := {}
Local aInfo 	 := {}
Local aPosGet	 := {}
Local aPosObj	 := {}
Local aPosSD1	 := {}
Local aStruSD1   := {}
Local aChave     := Array(5)
Local aNotas     := {}
Local aItIcm     := {}
Local aAmarrAFN	 := {}
Local lTemICM    := .F.
Local lAzFrete	 := SuperGetMv("MV_AZFRETE",.F.,.T.) // Indica se no conhecimento de frete, deve zerar a aliquota do item que tiver aliquota zerada na NF de origem

Local cItemSDE	 := ""
Local cCadastro	 := STR0001 //"Nota Fiscal de Conhecimento de Frete"
Local cArquivo 	 := ""
Local cPrefixo 	 := If(Empty(SF1->F1_PREFIXO),&(SuperGetMV("MV_2DUPREF")),SF1->F1_PREFIXO)
Local cItem		 := StrZero(0,Len(SD1->D1_ITEM))
Local cLocCQ	 := SuperGetMv("MV_CQ")
Local cQuery     := ""
Local cQrySF1    := Eval(bFiltraBrw,1)
Local cAliasSF1  := "SF1"
Local cAliasSD1  := "SD1"
Local cRatDesp	 := SuperGetMV("MV_RATDESP")
Local lCusFifo   := SuperGetMv("MV_CUSFIFO",.F.,.F.)
Local cIndex     := ""
Local cCond      := ""
Local cVarFoco  := "     "
Local cRecIss 	 := "1"

Local oDlg
Local oGetDados
Local oLivro

Local nOpc       := 0
Local nUsado	 := 0
Local nTotal	 := 0
Local nDifTotal	 := 0
Local nDifIcms   := 0
Local nDif       := 0
Local nDifBase   := 0
Local nPosProd   := 0
Local nPosNumCQ  := 0
Local nPosNota   := 0
Local nPosConta  := 0
Local nPosItCta  := 0
Local nPosCC     := 0
Local nPosOP     := 0
Local nPosSegUm  := 0
Local nPesoTotal := 0
Local nPosPeso   := 0
Local nPosClaFis := 0
Local nPosCLVL   := 0
Local nPosNfOri  := 0
Local nPosSeriOri:= 0
Local nPosItemOri:= 0
Local nPosCodLan := 0
Local nPosOper	 := 0
Local nPItem     := 0
Local nX         := 0
Local nY         := 0
Local nW         := 0
Local nPosicao   := 0
Local nTotNot    := 1
Local nTpRodape  := 0
Local nRecSF1	 := 0
Local nInfDiv    := 0
Local nRatDesp   := Val(SubStr(cRatDesp,At("DESP=",cRatDesp)+5,1))
Local nRatFrete  := Val(SubStr(cRatDesp,At("FR=",cRatDesp)+3,1))
Local nRatSeg    := Val(SubStr(cRatDesp,At("SEG=",cRatDesp)+4,1))
Local nMaxItem   := 0
Local nIndexSE2  := 0
Local nPosGetLoja:= IIF(TamSX3("A2_COD")[1]< 10,(2.5*TamSX3("A2_COD")[1])+(110),(2.8*TamSX3("A2_COD")[1])+(100))
Local cModRetPIS := GetNewPar( "MV_RT10925", "1" )
Local lPCCBaixa  := SuperGetMv("MV_BX10925",.T.,"2") == "1"  .and. (!Empty( SE5->( FieldPos( "E5_VRETPIS" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_VRETCOF" ) ) ) .And. ;
!Empty( SE5->( FieldPos( "E5_VRETCSL" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETPIS" ) ) ) .And. ;
!Empty( SE5->( FieldPos( "E5_PRETCOF" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETCSL" ) ) ) .And. ;
!Empty( SE2->( FieldPos( "E2_SEQBX"   ) ) ) .And. !Empty( SFQ->( FieldPos( "FQ_SEQDES"  ) ) ) )
Local nResto     := 0
Local lMt116SD1  := ExistBlock("MT116SD1")
Local lNfeDanfe  := .T.
Local aPages	 := {"HEADER"}
Local lRet116SD1 := .T.
Local lRet       := .T.
Local aAtuExc	 := {}
Local aCtbInf    := {}	//Array contendo os dados para contabilizacao online:
//		[1] - Arquivo (cArquivo)
//		[2] - Handle (nHdlPrv)
//		[3] - Lote (cLote)
//      [4] - Habilita Digitacao (lDigita)
//      [5] - Habilita Aglutinacao (lAglutina)
//      [6] - Controle Portugal (aCtbDia)
//		[7,x] - Campos flags atualizados na CA100INCL
//		[7,x,1] - Descritivo com o campo a ser atualizado (FLAG)
//		[7,x,2] - Conteudo a ser gravado na flag
//		[7,x,3] - Alias a ser atualizado
//		[7,x,4] - Recno do registro a ser atualizado

Local nLancAp	:=	0
Local aHeadCDA	:=	{}
Local aColsCDA	:=	{}
Local aBtnBack	:=	{}
Local aColsAux	:= {}

Local nCombo		:= 2
Local oCombo
Local oCodRet
Local aCodR	        :=	{}
Local cFornIss		:= Space(Len(SE2->E2_FORNECE))
Local cLojaIss		:= Space(Len(SE2->E2_LOJA))
Local dVencISS		:= CtoD("")
Local oRecIss
Local lTemIss		:= .F.

If lPccBaixa
	cModRetPis := "3"
Endif

If AliasIndic("CDA")
	aAdd(aTitles,"Lançamentos da Apuração de ICMS")
	nLancAp	:=	Len(aTitles)
EndIf

If lNfeDanfe .And. cPaisLoc == "BRA"
	Aadd(aTitles,"Informações DANFE") //
	nInfDiv := 	Len(aTitles)
	A103CargaDanfe()
	If Len(aNfeDanfe)>0
		aNfeDanfe[13]:=if(SF1->(FieldPos("F1_CHVNFE"))>0, CriaVar("F1_CHVNFE") ,"")
		If IsInCallStack("GFEA065In")
			//Usados na integração com o GFE
			If !Empty(cChvNFE)
				aNfeDanfe[13]:= cChvNFE
			EndIf
			If !Empty(cTPCTE)
				aNfeDanfe[18]:= cTPCTE
				//aNfeDanfe[18]:= "C"
			EndIf
		EndIF
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica o modo de atualizacao da rotina                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Do Case
	Case aRotina[nOpcx][4] == 6
		l116Inclui	:= .T.
		l103Visual	:= .F.
		INCLUI      := .T.
		ALTERA      := .F.
	Case aRotina[nOpcx][4] == 5
		l116Exclui	:= .T.
		cCadastro	 := STR0007 //"Excluir NF de Conhec. Frete"
		l103Visual	:= .T.
		INCLUI      := .F.
		ALTERA      := .F.
		nRecSF1	 := SF1->(RecNo())
	OtherWise
		l116Visual	:= .T.
		l103Visual	:= .T.
		INCLUI      := .F.
		ALTERA      := .F.
		nRecSF1	 := SF1->(RecNo())
EndCase
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declara as variaveis PrivateS                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cTipo	  := IIf(l116Inclui,"C",SF1->F1_TIPO)
Private cFormul	  := IIf(l116Inclui,IIf(aParametros[FORMUL]==2,"S","N"),SF1->F1_FORMUL)
Private cNFiscal  := IIf(l116Inclui,aParametros[NUMNF],SF1->F1_DOC)
Private cSerie	  := IIf(l116Inclui,aParametros[SERNF],SF1->F1_SERIE)
Private dDEmissao := IIf(l116Inclui,dDataBase,SF1->F1_EMISSAO)
Private cA100For  := IIf(l116Inclui,aParametros[FORNECE],SF1->F1_FORNECE)
Private cLoja     := IIf(l116Inclui,aParametros[LOJA],SF1->F1_LOJA)
Private cEspecie  := IIf(l116Inclui,CriaVar("F1_ESPECIE"),SF1->F1_ESPECIE)
If (l116Inclui .And. cA100For+cLoja <> SA2->A2_COD+SA2->A2_LOJA)
	SA2->(MsSeek(xFilial("SA2")+cA100For+cLoja))
EndIf
Private cCondicao := IIf(l116Inclui,SA2->A2_COND,SF1->F1_COND)
Private lReajuste  := .F.
Private lAmarra    := .F.
Private lConsLoja  := .F.
Private lPrecoDes  := .F.
Private lDataUCOM  := .F.
Private lAtuAmarra := .F.
Private n          := 1
Private nMoedaCor  := 1
Private aCols	   := {}
Private aHeader    := {}
Private aRatVei    := {}
Private aRatFro    := {}
Private aArraySDG  := {}
Private aRatAFN    := {}
Private bRefresh   := {|nX| NfeFldChg(nX,nY,,aFldCBAtu)}
Private bGDRefresh := {|| IIf(oGetDados<>Nil,(oGetDados:oBrowse:Refresh()),.F.) }		// Efetua o Refresh da GetDados
Private oFoco103
Private lMudouNum  := .F.
Private oLancApICMS

Private cDirf	   := Space(Len(SE2->E2_DIRF))
Private cCodRet	   := Space(Len(SE2->E2_CODRET))

If ( Type("aNFEDanfe") == "U" )
	PRIVATE aNFEDanfe := {}
EndIf

If ( Type("aDanfeComp") == "U" )
	Private aDanfeComp:= {}
EndIf

If Empty(cEspecie)
	If !Empty(cEspecie2)
		cEspecie := cEspecie2
	Else
		cEspecie := PadR("CTR",Len(SF1->F1_ESPECIE))
	EndIf
EndIf

Pergunte("MTA103",.F.)

lDigita     := (mv_par01==1)
lAglutina   := (mv_par02==1)
lReajuste   := (mv_par04==1)
lAmarra     := (mv_par05==1)
lGeraLanc   := (mv_par06==1)
lConsLoja   := (mv_par07==1)
IsTriangular((mv_par08==1))
nTpRodape   := (mv_par09)
lPrecoDes   := (mv_par10==1)
lDataUcom   := (mv_par11==1)
lAtuAmarra  := (mv_par12==1)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se a operacao pode ser feita                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If l116Inclui
	If !NfeVldIni(.F.,lGeraLanc)
		lContinua := .F.
	EndIf
ElseIf l116Exclui
	If !MaCanDelF1(nRecSF1,@aRecSC5,aRecSE2,.T.)
		lContinua := .F.
	EndIf
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Codigo do ISS de acordo com o cliente/fornecedor³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cRecIss  := Iif(SA2->A2_RECISS$"1S","1","2" )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem do aHeader                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX3")
dbSetOrder(1)
MsSeek("SD1")
While !Eof() .And. (SX3->X3_ARQUIVO == "SD1")
	If X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. AllTrim(SX3->X3_CAMPO) <> "D1_GERAPV" .And. ;
		AllTrim(SX3->X3_CAMPO) <> "D1_ITEMMED"
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ CAT83 - Nao adiciona campo ao aCols se parametro estiver desligado  |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Trim(SX3->X3_CAMPO)="D1_CODLAN" .And. !SuperGetMv("MV_CAT8309",.F.,.F.)
			dbSelectArea("SX3")
			dbSkip()
		EndIF
		
		nUsado++
		aadd(aHeader,{ TRIM(X3Titulo()),;
		SX3->X3_CAMPO,;
		SX3->X3_PICTURE,;
		SX3->X3_TAMANHO,;
		SX3->X3_DECIMAL,;
		SX3->X3_VALID,;
		SX3->X3_USADO,;
		SX3->X3_TIPO,;
		SX3->X3_ARQUIVO,;
		SX3->X3_CONTEXT})
		
		If SX3->X3_PROPRI =="U" .And. SX3->X3_VISUAL != "V"
			aadd(aCpos2,Alltrim(SX3->X3_CAMPO))
		EndIf
		Do Case
			Case SubStr(AllTrim(SX3->X3_CAMPO),3)=="_ITEM"
				nPItem := nUsado
			Case SubStr(AllTrim(SX3->X3_CAMPO),3)=="_COD"
				nPosProd := nUsado
			Case SubStr(alltrim(x3_campo),3) == "_TOTAL"
				nPosTotal := nUsado
			Case SubStr(alltrim(x3_campo),3) == "_VUNIT"
				nPosUnit  := nUsado
			Case SubStr(alltrim(x3_campo),3) == "_TES"
				nPosTES  := nUsado
			Case SubStr(alltrim(x3_campo),3) == "_UM"
				nPosUM  := nUsado
			Case SubStr(alltrim(x3_campo),3) == "_SEGUM"
				nPosSegum  := nUsado
			Case SubStr(alltrim(x3_campo),3) == "_NUMCQ"
				nPosNumCQ := nUsado
			Case SubStr(alltrim(x3_campo),3) == "_LOCAL"
				nPosLoc  := nUsado
			Case SubStr(alltrim(x3_campo),3) == "_PESO"
				nPosPeso := nUsado
			Case SubStr(alltrim(x3_campo),3) == "_CONTA"
				nPosConta := nUsado
			Case SubStr(alltrim(x3_campo),3) == "_ITEMCTA"
				nPosItCta := nUsado
			Case SubStr(alltrim(x3_campo),3) == "_CC"
				nPosCC := nUsado
			Case SubStr(alltrim(x3_campo),3) == "_OP"
				nPosOP := nUsado
			Case Subs(alltrim(x3_campo),3) == "_CLASFIS"
				nPosClaFis := nUsado
			Case Subs(alltrim(x3_campo),3) == "_CLVL"
				nPosCLVL := nUsado
			Case Subs(alltrim(x3_campo),3) == "_NFORI"
				nPosNfOri := nUsado
			Case Subs(alltrim(x3_campo),3) == "_SERIORI"
				nPosSeriOri := nUsado
			Case Subs(alltrim(x3_campo),3) == "_ITEMORI"
				nPosItemOri := nUsado
			Case Subs(alltrim(x3_campo),3) == "_CODLAN"
				nPosCodLan := nUsado
			Case Subs(alltrim(x3_campo),3) == "_OPER"
				nPosOper := nUsado
		EndCase
	EndIf
	dbSelectArea("SX3")
	dbSkip()
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Adiciona os campos de Alias e Recno ao aHeader para WalkThru.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ADHeadRec("SD1",aHeader)

If l116Inclui
	
	cMarca   := ThisMark()
	lInverte := ThisInv()
	
	dbSelectArea("SF1")
	
	SF1->(dbCommit())
	lQuery := .T.
	cAliasSF1 := "A116INCLUI"
	cAliasSD1 := cAliasSF1
	aStruSD1  := SD1->(dbStruct())
	
	cQuery := "SELECT SF1.F1_FILIAL, SF1.F1_DOC, SF1.F1_SERIE, SF1.F1_FORNECE, SF1.F1_LOJA, SF1.F1_TIPO,"
	cQuery += "       SF1.R_E_C_N_O_ SF1RECNO,   SF1.F1_OK,SD1.* "
	cQuery += "  FROM "+RetSqlName("SF1")+" SF1, "
	cQuery += RetSqlName("SD1")+" SD1 "
	cQuery += " WHERE "
	cQuery += cQrySF1 + " AND "
	If ( lInverte )
		cQuery    += "SF1.F1_OK<>'"+cMarca+"' AND "
	Else
		cQuery    += "SF1.F1_OK='"+cMarca+"' AND "
	EndIf
	cQuery += "     SF1.D_E_L_E_T_ = ' '"
	cQuery += " AND SD1.D1_FILIAL  = '"+xFilial("SD1")+"'"
	cQuery += " AND SD1.D1_SERIE   = SF1.F1_SERIE   "
	cQuery += " AND SD1.D1_DOC	   = SF1.F1_DOC 	"
	cQuery += " AND SD1.D1_FORNECE = SF1.F1_FORNECE "
	cQuery += " AND SD1.D1_LOJA    = SF1.F1_LOJA    "
	cQuery += " AND SD1.D_E_L_E_T_ = ' ' "
	cQuery += "ORDER BY "+SqlOrder(SF1->(IndexKey()))
	cQuery := ChangeQuery(cQuery)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSF1)
	
	For nX := 1 To Len(aStruSD1)
		If aStruSD1[nX][2]<>"C"
			TcSetField(cAliasSD1,aStruSD1[nX][1],aStruSD1[nX][2],aStruSD1[nX][3],aStruSD1[nX][4])
		EndIf
	Next nX
	
	While !Eof() .And. xFilial("SF1") == (cAliasSF1)->F1_FILIAL
		lSkip := .F.
		If IsMark("F1_OK",cMarca,lInverte)
			If lQuery
				aadd(aRecSF1Ori,(cAliasSF1)->SF1RECNO)
			Else
				aadd(aRecSF1Ori,(cAliasSF1)->(RecNo()))
			EndIf
			If !lQuery
				dbSelectArea("SD1")
				dbSetOrder(1)
				MsSeek(xFilial("SD1")+(cAliasSF1)->F1_DOC+(cAliasSF1)->F1_SERIE+(cAliasSF1)->F1_FORNECE+(cAliasSF1)->F1_LOJA)
			EndIf
			aChave[1] := (cAliasSF1)->F1_DOC
			aChave[2] := (cAliasSF1)->F1_SERIE
			aChave[3] := (cAliasSF1)->F1_FORNECE
			aChave[4] := (cAliasSF1)->F1_LOJA
			
			While !Eof() .And. (cAliasSD1)->D1_FILIAL == xFilial("SD1") .And.;
				(cAliasSD1)->D1_DOC == aChave[1] .And.;
				(cAliasSD1)->D1_SERIE == aChave[2] .And.;
				(cAliasSD1)->D1_FORNECE == aChave[3] .And.;
				(cAliasSD1)->D1_LOJA == aChave[4]
				
				If lMt116SD1
					lRet116SD1 := ExecBlock("MT116SD1",.F.,.F.,{(cAliasSD1)})
					If ValType(lRet116SD1) == "L" .And. !lRet116SD1
						dbSelectArea(cAliasSD1)
						dbSkip()
						Loop
					EndIf
				EndIf
				
				If (cAliasSD1)->D1_VALISS == 0
					If Len(aCols) > 9999
						lAglutProd := .F.
					EndIf
					
					If (cAliasSD1)->D1_ORIGLAN $"FD|F | D" .And. lAviso
						Aviso("",STR0045,{"OK"},2)//"Entre os itens selecionados ja existe um documento de frete e ou despesa de importacao vinculado."
						lAviso := .F.
					EndIf
					
					nX	:= aScan(aCols,{|x| x[nPosProd] == (cAliasSD1)->D1_COD .And.;
					x[nPosLoc] == (cAliasSD1)->D1_LOCAL .And.;
					x[nPosNumCQ] == (cAliasSD1)->D1_NUMCQ })
					If !lAglutProd .Or. nX==0
						aadd(aAmarrAFN, {})
						aadd(aCols,	Array(Len(aHeader)+1))
						nX	:= Len(aCols)
						If Empty(aChave[5])
							For nY := 1 to Len(aHeader)
								Do Case
									Case IsHeadRec(aHeader[nY][2])
										aCols[nX][nY] := 0
									Case IsHeadAlias(aHeader[nY][2])
										aCols[nX][nY] := "SD1"
									Case AllTrim(aHeader[nY][2]) == "D1_ITEM"
										cItem := Soma1(cItem,Len((cAliasSD1)->D1_ITEM))
										aCols[nX][nY] := cItem
									Case aHeader[nY][10] <> "V"
										aCols[nX][nY] := CriaVar(aHeader[nY][2])
									Case aHeader[nY][10] == "V" .And. GetSx3Cache(aHeader[nY][2],'X3_PROPRI') == 'U'
										aCols[nX][nY] := CriaVar(aHeader[nY][2])
								EndCase
								
								If SuperGetMv("MV_VEICULO") == "S" .And. AllTrim(aHeader[nY][2]) $ "D1_CODGRP/D1_CODITE"
									aCols[nX][nY] := CriaVar(aHeader[nY][2])
								EndIf
								
								aCols[nX][Len(aHeader)+1] := .F.
							Next nY
							aChave[5] := aClone(aCols[1])
						Else
							aCols[nX] := aClone(aChave[5])
						EndIf
					EndIf
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica os itens apontados ao SIGAPMS                    ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					dbSelectArea("AFN")
					dbSetOrder(2)
					MsSeek(xFilial("AFN")+(cAliasSD1)->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_ITEM))
					While !Eof() .And. xFilial("AFN")+(cAliasSD1)->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_ITEM)==;
						AFN_FILIAL+AFN_DOC+AFN_SERIE+AFN_FORNEC+AFN_LOJA+AFN_ITEM
						If AFN->AFN_REVISA==PmsAF8Ver(AFN->AFN_PROJET)
							aAdd(aAmarrAFN[nx],{AFN->AFN_PROJET,AFN->AFN_REVISA,AFN->AFN_TAREFA,(cAliasSD1)->D1_TOTAL*(AFN->AFN_QUANT/(cAliasSD1)->D1_QUANT),(cAliasSD1)->D1_PESO*(AFN->AFN_QUANT/SD1->D1_QUANT),0,0,cItem,(cAliasSD1)->D1_COD })
						EndIf
						dbSelectArea("AFN")
						dbSkip()
					EndDo
					aCols[nX,nPosProd]   := (cAliasSD1)->D1_COD
					aCols[nX,nPosLoc]    := (cAliasSD1)->D1_LOCAL
					aCols[nX,nPosTes]    := aParametros[TES]
					aCols[nX,nPosNumCQ]  := (cAliasSD1)->D1_NUMCQ
					aCols[nX,nPosUM]     := (cAliasSD1)->D1_UM
					If (!lAglutProd .And. lCusFifo)
						aCols[nX,nPosNfOri]  := (cAliasSD1)->D1_DOC
						aCols[nX,nPosSeriOri]:= (cAliasSD1)->D1_SERIE
						aCols[nX,nPosItemOri]:= (cAliasSD1)->D1_ITEM
					EndIf
					SF4->(DbSeek (xFilial ("SF4")+aCols[nX,nPosTes]))
					SB1->(DbSeek (xFilial ("SB1")+aCols[nX,nPosProd]))
					
					If !Empty( nPosSegUM )
						aCols[nX,nPosSegUM] := (cAliasSD1)->D1_SEGUM
					EndIf
					If nPosClaFis<>0
						aCols[nX, nPosClaFis]:= Iif( GetNewPar("MV_STFRETE",.F.) , "0" , SB1->B1_ORIGEM ) + Iif (SF4->(FieldPos ("F4_SITTRIB"))>0, SF4->F4_SITTRIB, "  ")   // Comforme parecer da Consultoria Tributaria emitido no chamado SCSFW2
					EndIf
					If nPosConta >0
						aCols[nX,nPosConta] := (cAliasSD1)->D1_CONTA
					Endif
					If nPosItCta >0
						aCols[nX,nPosItCta] := (cAliasSD1)->D1_ITEMCTA
					Endif
					If nPosCC >0
						aCols[nX,nPosCC]    := (cAliasSD1)->D1_CC
					Endif
					If nPosCLVL >0
						aCols[nX,nPosCLVL]  := (cAliasSD1)->D1_CLVL
					Endif
					aCols[nX,nPosTotal] += (cAliasSD1)->D1_TOTAL
					aCols[nX,nPosPeso]  += (cAliasSD1)->D1_PESO
					nPesoTotal += (cAliasSD1)->D1_PESO
					
					nTotal += (cAliasSD1)->D1_TOTAL
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ CAT83	                  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If nPosCodLan >0 .And. FindFunction("A103CAT83")
						aCols[nX,nPosCodLan]:=A103CAT83(nX)
					EndIf
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Tratamento para utilizacao do campo Tipo de Operacao (D1_OPER)
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If nPosOper >0
						aCols[nX,nPosOper] := Space(TamSx3("D1_OPER")[1])
					Endif
					
					If lM116ACOL
						ExecBlock("M116ACOL",.F.,.F.,{cAliasSD1,nX,aChave})
					EndIf
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Inclui o item do acols que a aliquota eh zero                ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If (cAliasSD1)->D1_PICM == 0
						Aadd(aItIcm,nX)
					Else
						lTemIcm := .T.
					EndIf
					FillCTBEnt(cAliasSD1,nX)
				Else
					lTemIss := .T.
				EndIf
				dbSelectArea(cAliasSD1)
				dbSkip()
				lSkip := lQuery
			EndDo
			If lTemIss
				MsgInfo("Há itens que não serão carregados para geração do conhecimento de frete, pois possuem valor de imposto ISS.")
			Endif
		EndIf
		If !lSkip
			dbSelectArea(cAliasSF1)
			dbSkip()
		EndIf
	EndDo
	If lQuery
		dbSelectArea(cAliasSF1)
		dbCloseArea()
		dbSelectArea("SF1")
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Rateio da do frete nos itens do conhecimento de frete               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nX := 1 to Len(aCols)
		If nRatFrete == 2 .And. nPesoTotal > 0
			aCols[nX][nPosTotal]	:= NoRound((aCols[nX][nPosPeso]/nPesoTotal)*aParametros[VALOR],2,@nDifTotal)
			If Round(nDifTotal,2) >= 0.01
				aCols[nX][nPosTotal]	+= Round(nDifTotal,2)
				nDifTotal				-= Round(nDifTotal,2)
			EndIf
			aCols[nX][nPosUnit]	:= aCols[nX][nPosTotal]
			
			For nW := 1 to Len(aAmarrAFN[nX])
				nResto := 0
				aAmarrAFN[nX,nW][6] := NoRound((aAmarrAFN[nX,nW][5]/nPesoTotal)*aParametros[VALOR],2,@nResto)
				aAmarrAFN[nX,nW][7]	 := aCols[nX][nPosTotal]
				If Round(nResto,2) >= 0.01
					aAmarrAFN[nX,nW][6] += Round(nResto,2)
				EndIf
			Next nW
			
		Else
			aCols[nX][nPosTotal]	:= NoRound((aCols[nX][nPosTotal]/nTotal)*aParametros[VALOR],2,@nDifTotal)
			If Round(nDifTotal,2) >= 0.01
				aCols[nX][nPosTotal]	+= Round(nDifTotal,2)
				nDifTotal				-= Round(nDifTotal,2)
			EndIf
			aCols[nX][nPosUnit]	:= aCols[nX][nPosTotal]
			
			For nW := 1 to Len(aAmarrAFN[nX])
				nResto := 0
				aAmarrAFN[nX,nW][6] := NoRound((aAmarrAFN[nX,nW][4]/nTotal)*aParametros[VALOR],2,@nResto)
				aAmarrAFN[nX,nW][7] := aCols[nX][nPosTotal]
				If Round(nResto,2) >= 0.01
					aAmarrAFN[nX,nW][6] += Round(nResto,2)
				EndIf
			Next nW
		EndIf
		
		If aCols[nX][nPosTotal] == 0
			aCols[nX][Len(aHeader)+1] := .T.
		Endif
		
	Next nX
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Tratamento da quebra por item de nota                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cFormul=="S"
		nMaxItem   := a460NumIt(cSerie,.T.)
		nY := 0
		For nX := 1 To Len(aCols)
			If nY==0
				aadd(aNotas,{})
			EndIf
			If !aCols[nX,len(aHeader) + 1]
				aadd(aNotas[Len(aNotas)],aCols[nX])
			EndIf
			nY++
			If nY == nMaxItem
				nY := 0
			EndIf
		Next nX
	Else
		If len(aCols) > 0
			// Adiciona no array aNotas apenas os itens do aCols que nao estao deletados
			aColsAux := {}
			For nX := 1 To Len(aCols)
				If !aCols[nX,len(aHeader) + 1]
					aadd(aColsAux,aCols[nX])
				EndIf
			Next nX
			aadd(aNotas,aColsAux)
		EndIf
	EndIf
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Abertura da funcao fiscal                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MaFisIni(cA100For,cLoja,"F","C","R",MaFisRelImp("MT100",{"SD1","SF1"}),"F",.T.)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Altera a origem do conhecimento de Frete                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(cUFOri)
		MaFisAlt("NF_UFORIGEM",cUFOri)
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Trava os registros do SF1 - Exclusao                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If l116Exclui
		If !SoftLock("SF1")
			lContinua := .F.
		Endif
	EndIf
	If l116Visual .Or. l116Exclui
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Monta array contendo os registros fiscais SF3.          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SF3")
		dbSetOrder(4)
		MsSeek(xFilial("SF3")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_DOC+SF1->F1_SERIE)
		While !Eof().And.lContinua.And. xFilial("SF3")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_DOC+SF1->F1_SERIE == ;
			F3_FILIAL+F3_CLIEFOR+F3_LOJA+F3_NFISCAL+F3_SERIE
			If Substr(SF3->F3_CFO,1,1) < "5"
				aadd(aRecSF3,RecNo())
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Trava os registros do SF3 - exclusao                 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If l116Exclui
					If !SoftLock("SF3")
						lContinua := .F.
					Endif
				EndIf
			EndIf
			dbSkip()
		End
	EndIf
	
	If l116Exclui
		aRecSF8	:=	A116GetSF8(@lContinua)
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta o Array contendo as duplicatas SE2             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ( l116Visual .Or. l116Exclui ) .And. Empty(aRecSE2)
		dbSelectArea('SE2')
		dbSetOrder(6)
		If MsSeek(xFilial("SE2")+SF1->F1_FORNECE+SF1->F1_LOJA+cPrefixo+SF1->F1_DOC)
			While !Eof() .And. lContinua .And.xFilial("SE2")+SF1->F1_FORNECE+SF1->F1_LOJA+cPrefixo+SF1->F1_DOC==;
				E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM .And. lContinua
				If !(SE2->E2_VALOR == SE2->E2_SALDO)
					HELP(" ",1,"A100FINBX")
					lContinua := .F.
					Exit
				EndIf
				aadd(aRecSE2,RecNo())
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Trava os registros do SE2 - exclusao                 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If l116Exclui
					If !SoftLock("SE2")
						lContinua := .F.
					Endif
				EndIf
				dbSkip()
			EndDo
		EndIf
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz a montagem do aCols com os dados do SD1                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SD1")
	dbSetOrder(1)
	MsSeek(xFilial('SD1')+cNFiscal+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
	While !Eof().And.lContinua .And. SD1->D1_FILIAL+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA ==	;
		xFilial('SD1')+cNFiscal+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Trava os registros na alteracao e  exclusao            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If l116Exclui
			If !SoftLock("SD1")
				lContinua := .F.
			Else
				aadd(aRecSD1,{RecNo(),SD1->D1_ITEM })
			Endif
		EndIf
		aadd(aCols,Array(Len(aHeader)+1))
		For nY := 1 to Len(aHeader)
			If IsHeadRec(aHeader[nY][2])
				aCols[Len(aCols)][nY] := SD1->(Recno())
			ElseIf IsHeadAlias(aHeader[nY][2])
				aCols[Len(aCols)][nY] := "SD1"
			ElseIf ( aHeader[nY][10] != "V")
				aCols[Len(aCols)][nY] := FieldGet(FieldPos(aHeader[nY][2]))
			Else
				aCols[Len(aCols)][nY] := CriaVar(aHeader[nY][2])
			EndIf
			aCols[Len(aCols)][Len(aHeader)+1] := .F.
		Next nY
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Inicia a Carga do item nas funcoes MATXFIS  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		MaFisIniLoad(Len(aCols))
		For nX := 1 to Len(aAuxRefSD1)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Carrega os valores direto do SD1.           ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			MaFisLoad(aAuxRefSD1[nX][2],&("SD1->"+aAuxRefSD1[nX][1]),Len(aCols))
		Next nX
		MaFisEndLoad(Len(aCols),2)
		dbSelectArea("SD1")
		dbSkip()
	EndDo
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta um Array de Notas conforme o numero de itens      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	aadd(aNotas,aCols)
	
EndIf

If lContinua .And. Len(aNotas) > 0 .And. Len(aNotas[1]) > 0
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o numero maximo de itens da nota fiscal                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nX := 1 To Len(aNotas)
		If nX >= 2 .And. cFormul == "S"
			cNFiscal := NxtSX5Nota(cSerie)
		EndIf
		If l116Inclui
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Abertura da funcao fiscal                                           ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			MaFisIni(cA100For,cLoja,"F","C","R",MaFisRelImp("MT100",{"SD1","SF1"}),"F",.T.,,,,cEspecie)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Altera a origem do conhecimento de Frete                            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !Empty(cUFOri)
				MaFisAlt("NF_UFORIGEM",cUFOri)
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Preparacao do acols para o conhecimento de frete                    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aCols := aNotas[nX]
			If l116Inclui
				cItem := StrZero(0,Len(SD1->D1_ITEM))
				For nY := 1 To Len(aCols)
					cItem := Soma1(cItem,Len(SD1->D1_ITEM))
					aCols[nY][nPItem]   := cItem
					For nw := 1 to Len(aAmarrAFN[ny])
						aAmarrAFN[ny,nw][8]	 := cItem
					Next nw
				Next nY
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Carrega os impostos                                                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			MaColsToFis(aHeader,aCols,,"MT100",.T.)
			
			If lTemICM .And. lAzFrete
				For nX := 1 to Len(aItIcm)
					MaFisAlt("IT_ALIQICM",0,aItIcm[nX])
				Next
			EndIf
			If aParametros[16]<>0 .And. aParametros[17]<>0
				MaFisAlt("NF_BASESOL",aParametros[16])
				MaFisAlt("NF_VALSOL",aParametros[17])
			EndIf
			
			MaFisToCols(aHeader,aCols,,"MT100")
			
		Else
			aCols := aNotas[nX]
		EndIf
		
		aObjects := {}
		aadd( aObjects, { 0,    41, .T., .F. } )
		aadd( aObjects, { 100, 100, .T., .T. } )
		aadd( aObjects, { 0,    75, .T., .F. } )
		
		aInfo := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 3, 3 }
		
		aPosObj := MsObjSize( aInfo, aObjects )
		
		aPosGet := MsObjGetPos(aSizeAut[3]-aSizeAut[1],310,;
		{{8,35,75,100,194,220,260,280},;
		{8,35,75,100,nPosGetLoja,194,220},;
		{5,70,160,205,295},;
		{6,34,200,215},;
		{6,34,75,103,148,164,230,253},;
		{6,34,200,218,280},;
		{11,50,150,190},;
		{273,130,190,293,205},;
		{005,035,075,105,145,175,215,245}})
		
		DEFINE MSDIALOG oDlg FROM aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] TITLE cCadastro Of oMainWnd PIXEL
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Objeto criado para receber o foco quando pressionado o botao confirma ³
		//³ da dialog. Usado para identificar quando foi pressionado o botao      ³
		//³ confirma, atraves do parametro passado ao lostfocus                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		@ 100000,100000 MSGET oFoco103 VAR cVarFoco SIZE 12,09 PIXEL OF oDlg
		oFoco103:Cargo := {.T.,.T.}
		oFoco103:Disable()
		
		NfeCabDoc(oDlg,{aPosGet[1],aPosGet[2],aPosObj[1]},@bCabOk,.F..Or.l103Visual,,,,,@nCombo,@oCombo,@cCodRet,@oCodRet,,,@cRecIss)
		
		oGetDados := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcx,'A116LinOk','A116TudOk','+D1_ITEM',.T.,aCpos2,,,900,,,,'NfeDelItem')
		oGetDados:oBrowse:bGotFocus	:= bCabOk
		
		oFolder := TFolder():New(aPosObj[3,1],aPosObj[3,2],aTitles,{"AHEADER"},oDlg,,,, .T., .F.,aPosObj[3,4]-aPosObj[3,2],aPosObj[3,3]-aPosObj[3,1],)
		oFolder:bSetOption := {|nDst| NfeFldChg(nDst,oFolder:nOption,oFolder,aFldCBAtu)}
		bRefresh := {|nX| NfeFldChg(nX,oFolder:nOption,oFolder,aFldCBAtu)}
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Folder dos Totalizadores                                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oFolder:aDialogs[1]:oFont := oDlg:oFont
		NfeFldTot(oFolder:aDialogs[1],aValores,aPosGet[3],@aFldCBAtu[1])
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Folder dos Fornecedores                                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oFolder:aDialogs[2]:oFont := oDlg:oFont
		NfeFldFor(oFolder:aDialogs[2],aInfForn,{aPosGet[4],aPosGet[5],aPosGet[6]},@aFldCBAtu[2])
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Folder das Despesas acessorias e descontos                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oFolder:aDialogs[3]:oFont := oDlg:oFont
		NfeFldDsp(oFolder:aDialogs[3],aValores,{aPosGet[7],aPosGet[8]},@aFldCBAtu[3])
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Folder dos Livros Fiscais                                    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oFolder:aDialogs[4]:oFont := oDlg:oFont
		oLivro := MaFisBrwLivro(oFolder:aDialogs[4],{5,4,( aPosObj[3,4]-aPosObj[3,2] ) - 10,53},.T.,IIf(!.F.,aRecSF3,Nil),.T.)
		aFldCBAtu[4] := {|| oLivro:Refresh()}
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Folder dos Impostos                                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oFolder:aDialogs[5]:oFont := oDlg:oFont
		MaFisRodape(nTpRodape,oFolder:aDialogs[5],,{5,4,( aPosObj[3,4]-aPosObj[3,2] )-10,53},@bIPRefresh,l103Visual,@cFornIss,@cLojaIss,aRecSE2,@cDirf,@cCodRet,@oCodRet,@nCombo,@oCombo,@dVencIss,@aCodR,@cRecIss,@oRecIss)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Folder do Financeiro                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oFolder:aDialogs[6]:oFont := oDlg:oFont
		NfeFldFin(oFolder:aDialogs[6],l103Visual,aRecSE2,( aPosObj[3,4]-aPosObj[3,2] ) - 101,,@aHeadSE2,@aColsSE2,@aHeadSEV,@aColsSEV,@aFldCbAtu[6],.T.,@cModRetPIS,lPccBaixa)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Folder dos Lancamentos Apuracao ICMS - Sped                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If AliasIndic("CDA") .And. nLancAp>0
			oFolder:aDialogs[nLancAp]:oFont := oDlg:oFont
			oLancApICMS := a103xLAICMS(oFolder:aDialogs[nLancAp],{5,4,( aPosObj[3,4]-aPosObj[3,2] )-10,53},@aHeadCDA,@aColsCDA,l116Visual,l116Inclui,"MATA116")
			If AliasIndic("CDA") .And. Type("oLancApICMS")=="O"  .And. cPaisLoc == "BRA" //grazi
				a103AjuICM(0) //Funcao para atualizar o objeto do mata103 (TFOLDER) com as informacoes referentes ao lancamento fiscal.
			EndIf
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Montagem do Folder Informacoes Diversas                             |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oFolder:aDialogs[nInfDiv]:oFont := oDlg:oFont
		NfeFldDiv(oFolder:aDialogs[nInfDiv],{aPosGet[9]})
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Transfere o foco para a getdados - nao retirar                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oFoco103:bGotFocus := { || oGetDados:oBrowse:SetFocus() }
		
		ACTIVATE MSDIALOG oDlg ON INIT (EnchoiceBar(oDlg,{||Eval(bRefresh,IIf(oFolder:nOption==6,1,6)).And.oFoco103:Enable(),oFoco103:SetFocus(),oFoco103:Disable(),If(oGetDados:TudoOk() .And.  NfeTOkSEV(@aHeadSev, @aColsSev,.F.) .And. a116CDAOk() .And. oFoco103:Cargo[1].And. If(l116Inclui,NfeTotFin(aHeadSE2,aColsSE2,.F.),.T.) .And. NfeVldSEV(oFoco103:Cargo[2],aHeader,aCols,aHeadSEV,aColsSEV) .And. IIf(FindFunction("A103ChamaHelp") .And. l116Inclui,A103ChamaHelp(),.T.).And. NfeNextDoc(@cNFiscal,@cSerie,l116Inclui),(nOpc:=1,oDlg:End()),Eval({||nOpc:=0,oFoco103:Cargo[1] :=.T.}))},{||nOpc:=0,oDlg:End()},,aButtons),Eval(bRefresh))
		
		SetKey( VK_F4, Nil )
		
		
		If nOpc == 1 .And. (l116Inclui.Or.l116Exclui)
			
			If lRet
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Limpa o Filtro do SF1 para ser executada a gravacao em AS400 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If TcSrvType()=="AS/400"
					SF1->(dbClearFilter())
				Endif
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Inicializa a gravacao atraves nas funcoes MATXFIS         ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				MaFisWrite()
				
				Begin Transaction
				If l116Exclui
					aAtuExc := A116CredP(l116Exclui,aRecSF8)
				Endif
				a103Grava(l116Exclui,lGeraLanc,	lDigita,lAglutina, aHeadSE2, aColsSE2,aHeadSEV,	aColsSEV,@nRecSF1,aRecSD1,aRecSE2,aRecSF3,aRecSC5,aHeadSDE,aColsSDE,aRecSDE,.T.,.F.,@aRecSF1Ori,aRatVei,aRatFro,Nil,Nil,Nil,Nil,Nil,Nil,Nil,nIndexSE2,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,aCodR,cRecIss,Nil,aCtbInf,aNfeDanfe)
				A116Grava(l116Exclui,nRecSF1,aRecSF1Ori,aRecSF8,aAmarrAFN,aAtuExc)
				a103GrvCDA(l116Exclui,"E",cEspecie,cFormul,cNFiscal,cSerie,cA100For,cLoja)
				
				End Transaction
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Executa gravacao da contabilidade     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If Len(aCtbInf) != 0
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Cria nova transacao para garantir atualizacao do documento ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					Begin Transaction
					cA100Incl(aCtbInf[1],aCtbInf[2],3,aCtbInf[3],aCtbInf[4],aCtbInf[5],,,,aCtbInf[7],,aCtbInf[6])
					End Transaction
				EndIf
				
				//If !InTransact()
				//	SF1->(dbSetOrder(1))
				//	Eval(bFiltraBrw)
				//Endif
			EndIf
		EndIf
		
		If nOpc == 0
			lMsErroAuto := .T.
		EndIf
		
		MaFisEnd()
	Next nX
EndIf

If l116Exclui
	MsUnlockAll()
EndIf

CloseBrowse()

SF1->(dbSetOrder(1))
SF1->(dbSeek(xFilial("SF1")))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Limpa a variavel dMudaEmi                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If FindFunction("SetVar113")
	SetVar113(cToD(""))
EndIf

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A116LinOk ³ Autor ³ Edson Maricate        ³ Data ³08.02.2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Critica se a linha digitada esta' Ok                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA116                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A116LINOK()
Local lRet	:= .F.
Local aArea	:= GetArea()
Local nPosCod,nPosUm,nPosQuant,nPosVUnit,nPosTotal
Local nPosTes,nPosCfo
Local nx := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica preenchimento dos campos da linha do acols      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If CheckCols(n,aCols)
	
	For nX:= 1 To Len(aHeader)
		cCampo:=AllTrim(aHeader[nX][2])
		Do Case
			Case cCampo == 'D1_COD'
				nPosCod		:= nX
			Case cCampo == 'D1_UM'
				nPosUm		:= nX
			Case cCampo == 'D1_QUANT'
				nPosQuant	:= nX
			Case cCampo == 'D1_VUNIT'
				nPosVunit	:= nX
			Case cCampo == 'D1_TOTAL'
				nPosTotal 	:= nX
			Case cCampo == 'D1_TES'
				nPosTes		:= nX
			Case cCampo == 'D1_CF'
				nPosCFO		:= nX
			Case cCampo == 'D1_LOCAL'
				nPosLoc    := nX
		EndCase
	Next nX
	
	If !aCols[n][Len(aCols[n])]
		Do Case
			Case Empty(aCols[n][nPosCod]) .Or. ;
				Empty(aCols[n][nPosVUnit]) .Or. ;
				Empty(aCols[n][nPosTotal]).Or. ;
				Empty(aCols[n][nPosCFO])  .Or. ;
				Empty(aCols[n][nPosTES])
				Help("  ",1,"A100VZ")
			Case !ExistCpo('SF4',aCols[n][nPostes])
				lRet := .F.
			OtherWise
				lRet := .T.
		EndCase
	Else
		lRet := .T.
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica a permissao do armazem. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lRet .And. (VAL(GetVersao(.F.)) == 11 .And. GetRpoRelease() >= "R6" .Or. VAL(GetVersao(.F.))  > 11) .And. FindFunction("MaAvalPerm")
		lRet := MaAvalPerm(3,{aCols[n][nPosLoc],aCols[n][nPosCod]})
	EndIf
	
	RestArea(aArea)
EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A116TudOk ³ Autor ³ Edson Maricate        ³ Data ³08.02.2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Critica se as linhas digitadas estao OK.                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA116                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A116Tudok()

Local lRet		:= .T.
Local lVerChv   := SuperGetMv("MV_VCHVNFE",.F.,.F.)
Local cNFForn   := ""
Local nNFNum    := ""
Local nNFSerie	:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica a condicao de pagamento.           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If MaFisRet(,"NF_BASEDUP") > 0 .And. Empty(cCondicao)
	HELP("  ",1,"A100COND")
	lRet := .F.
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica a natureza                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If MaFisRet(,"NF_BASEDUP") > 0 .And. Empty(MaFisRet(,"NF_NATUREZA")) .And. cTipo<>"D"
	If SuperGetMV("MV_NFENAT") .And. !SuperGetMV("MV_MULNATP")
		Help("  ",1,"A103NATURE")
		lRet := .F.
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o total da NF esta negativo/zerado devido ao valor do desconto |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If MaFisRet(,"NF_TOTAL")<=0
	Help("  ",1,'TOTAL')
	lRet := .F.
EndIf

If lRet .And. lVerChv .And. cFormul == "N" .And. cTipo<>"D" .And. !Empty(aNfeDanfe[13])
	cNFForn  := SubStr(aNfeDanfe[13],7,14)			// CNPJ Emitente conforme manual Nota Fiscal Eletrônica
	nNFNum   := Val(SubStr(aNfeDanfe[13],26,9))		// Número da nota conforme manual Nota Fiscal Eletrônica
	nNFSerie := Val(SubStr(aNfeDanfe[13],23,3))		// Série da nota conforme manual Nota Fiscal Eletrônica
	If AllTrim(SA2->A2_CGC) == cNFForn .And. Val(cNFiscal) == nNFNum .And. Val(cSerie) == nNFSerie
		lRet := .T.
	Else
		Aviso(STR0039,"STR0052",{"STR0051"})
		lRet := .F.
	EndIf
EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A116Grava ³ Autor ³ Edson Maricate        ³ Data ³08.02.2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Complementa a gravacao da NF de Frete                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA116                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A116Grava(l116Exclui,nRecSF1,aRecSF1Ori,aRecSF8,aAmarrAFN,aAtuExc)

Local aArea	    := GetArea()
Local aAreaSF1	:= SF1->(GetArea())
Local aAreaSD1	:= SD1->(GetArea())

Local nX        := 0
Local nY        := 0
Local nW        := 0
Local nA        := 0
Local nDecAFN   := TamSX3("AFN_QUANT")[2]
Local nDecSD1   := TamSX3("D1_CUSTO")[2]
Local nSD1Qtd   := 0
Local nInd      := 0
Local aCusto    := {}
Local aSD1Vlr   := {}
Local cMvEstado := SuperGetMV("MV_ESTADO")
Local nResult   := 0
Local nLimite   := 0
Local nLimAtu	:= 0
Local nTotal    := 0
Local nTotalCP  := 0
Local nDifTotal := 0
Local aResult   := {}
Local lContinua := .F.
Local aAtuSD1	:= {}

Default aAtuExc := {}

If !l116Exclui
	dbSelectArea("SF1")
	MsGoto(nRecSF1)
	cNfFrete := SF1->F1_DOC
	cSeFrete := SF1->F1_SERIE
	cForFrete:= SF1->F1_FORNECE
	cLojFrete:= SF1->F1_LOJA
	For nX := 1 to Len(aRecSF1Ori)
		dbSelectArea("SF1")
		MsGoto(aRecSF1Ori[nX])
		dbSelectArea("SF8")
		RecLock("SF8",.T.)
		SF8->F8_FILIAL	:= xFilial("SF8")
		SF8->F8_DTDIGIT := SF1->F1_DTDIGIT
		SF8->F8_NFDIFRE	:= cNfFrete
		SF8->F8_SEDIFRE	:= cSeFrete
		SF8->F8_TRANSP	:= cForFrete
		SF8->F8_LOJTRAN	:= cLojFrete
		SF8->F8_NFORIG	:= SF1->F1_DOC
		SF8->F8_SERORIG	:= SF1->F1_SERIE
		SF8->F8_FORNECE	:= SF1->F1_FORNECE
		SF8->F8_LOJA	:= SF1->F1_LOJA
		SF8->F8_TIPO	:= "F"
		MsUnlock()
		dbSelectArea("SF1")
		RecLock("SF1",.F.)
		SF1->F1_ORIGLAN	:= If(SF1->F1_ORIGLAN==" D","FD","F ")
		SF1->F1_OK      := ""
		MsUnlock()
		
		nSD1Qtd   := 0
		dbSelectArea("SD1")
		dbClearFilter()
		dbSetOrder(1)
		MsSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
		While ( !Eof() .And. SD1->D1_FILIAL == xFilial("SD1") .And.;
			SD1->D1_DOC    == SF1->F1_DOC    .And.;
			SD1->D1_SERIE  == SF1->F1_SERIE  .And.;
			SD1->D1_FORNECE== SF1->F1_FORNECE.And.;
			SD1->D1_LOJA   == SF1->F1_LOJA )
			RecLock("SD1",.F.,.T.)
			SD1->D1_ORIGLAN   := If(SD1->D1_ORIGLAN==" D","FD","F ")
			MsUnlock()
			If SD1->D1_QUANT >0
				aAdd( aSD1Vlr ,{ cNFFrete,cSeFrete,cForFrete,cLojFrete,SD1->D1_COD,SD1->D1_QUANT } )
			EndIf
			
			//Calculo Crédito Presumido Santa Catarina
			//RICMS - Anexo 02 - Benefícios Fiscais - Capitulo III (Art. 18)
			If cMvEstado=="SC"
				dbSelectArea("SF4")
				SF4->(dbClearFilter())
				SF4->(dbSetOrder(1))
				SF4->(dbSeek(xFilial("SF4")+SD1->D1_TES))
				
				If SF4->(FieldPos("F4_CRDPRES"))>0
					dbSelectArea("SFT")
					SFT->(dbClearFilter())
					SFT->(dbSetOrder(1))
					SFT->(dbSeek(xFilial("SFT")+"E"+SD1->D1_SERIE+SD1->D1_DOC+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_ITEM+SD1->D1_COD))
					// Adiciona ao vetor os itens e seus respectivos limites de credito presumido
					aAdd(aResult, { SD1->D1_FILIAL,;
					SD1->D1_DOC,;
					SD1->D1_SERIE,;
					SD1->D1_FORNECE,;
					SD1->D1_LOJA,;
					SD1->D1_COD ,;
					SD1->D1_ITEM,;
					SD1->D1_TOTAL,;
					NoRound((SFT->FT_VALCONT * SF4->F4_CRDPRES) / 100,2),;
					SD1->D1_CRPRESC})
					lContinua :=.T.
				EndIf
			EndIf
			dbSelectArea("SD1")
			dbSkip()
		EndDo
	Next nX
	
	//Continuacao do Calculo Credito Presumido SC
	If lContinua
		
		// Atualizar os dados das notas originais
		For nX := 1 to Len(aRecSF1Ori)
			
			nResult  := 0
			nLimite  := 0
			nLimAtu	 := 0
			nTotal   := 0
			nTotalCP := 0
			
			dbSelectArea("SF1")
			MsGoto(aRecSF1Ori[nX])
			
			// obtem o valor total de cada nota original
			For nY := 1 to Len(aResult)
				If (aResult[nY][1] == SF1->F1_FILIAL .And. aResult[nY][2] == SF1->F1_DOC .And. aResult[nY][3] == SF1->F1_SERIE  .And. aResult[nY][4] == SF1->F1_FORNECE .And. aResult[nY][5] == SF1->F1_LOJA)
					nTotal += aResult[nY][8]
				EndIf
			Next nY
			
			// Atualizar os itens da nota original com o valor de crédito presumido
			dbSelectArea("SD1")
			dbClearFilter()
			dbSetOrder(1)
			MsSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
			Do While ( !Eof() .And. SD1->D1_FILIAL == xFilial("SD1") .And.;
				SD1->D1_DOC    == SF1->F1_DOC    .And.;
				SD1->D1_SERIE  == SF1->F1_SERIE  .And.;
				SD1->D1_FORNECE== SF1->F1_FORNECE.And.;
				SD1->D1_LOJA   == SF1->F1_LOJA )
				
				// Localizar o item na NF de origem
				If (nY := aScan( aResult, {|x| x[1] == SD1->D1_FILIAL .and. x[2] == SD1->D1_DOC .and. x[3] == SD1->D1_SERIE .and. x[4] == SD1->D1_FORNECE .and. x[5] == SD1->D1_LOJA .and. x[6] == SD1->D1_COD .and. x[7] == SD1->D1_ITEM .and. x[9] > 0 })) > 0
					
					// Definir o limite de crédito presumido para o item
					nLimite := NoRound((aResult[nY][8]/nTotal)*aParametros[VALOR],2,@nDifTotal)
					nLimAtu := Iif(Round(nDifTotal,2) >= 0.01,nLimite+=Round(nDifTotal,2),nLimite)
					nLimite += Iif(aResult[nY][10]>0,NoRound(aResult[nY][10],2,@nDifTotal),0)
					If Round(nDifTotal,2) >= 0.01
						nLimite	  += Round(nDifTotal,2)
						nDifTotal -= Round(nDifTotal,2)
					EndIf
					
					// Define qual e o valor do crédito presumido para o item
					nResult := IIf( (aResult[nY][9] > nLimite), nLimite, aResult[nY][9])
					
					// Atualizar os itens da nota original
					RecLock("SD1",.F.,.T.)
					SD1->D1_CRPRESC := nResult
					MsUnlock()
					
					//Alimento o array com os valores dos creditos presumidos calculados, para atualizar
					//depois nos itens do conhecimento de frete.
					aAdd(aAtuSD1, { cNfFrete,;
					cSeFrete,;
					cForFrete,;
					cLojFrete,;
					SD1->D1_COD ,;
					SD1->D1_ITEM,;
					Iif(nLimite<>nResult,nResult-aResult[nY][10],nLimAtu)})
					
					// Atualizar os itens do livro fiscal da nota original
					// com o valor de crédito presumido apurado
					dbSelectArea("SFT")
					SFT->(dbClearFilter())
					SFT->(dbSetOrder(1))
					SFT->(dbSeek(xFilial("SFT")+"E"+SD1->D1_SERIE+SD1->D1_DOC+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_ITEM+SD1->D1_COD))
					If SFT->(FieldPos("FT_CRDPRES"))>0
						RecLock("SFT",.F.)
						SFT->FT_CRDPRES := SD1->D1_CRPRESC
						MsUnlock()
					EndIf
					
					// Acumular o valor do crédito presumido
					nTotalCP += SD1->D1_CRPRESC
				EndIf
				dbSelectArea("SD1")
				dbSkip()
			EndDo
			
			// Atualizar o livro fiscal da nota original
			// com o valor de crédito presumido apurado
			dbSelectArea("SF3")
			SF3->(dbClearFilter())
			SF3->(dbSetOrder(4))
			SF3->(dbSeek(xFilial("SF3")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_DOC+SF1->F1_SERIE))
			If !EOF() .And. SF3->(FieldPos("F3_CRDPRES"))>0
				RecLock("SF3",.F.)
				SF3->F3_CRDPRES := nTotalCP
				MsUnlock()
			EndIf
		Next nX
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualizo os itens do conhecimento com os valores do cred pres³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nA := 1 to Len(aAtuSD1)
		SD1->(dbSetOrder(1))
		If SD1->(MsSeek(xFilial("SD1")+aAtuSD1[Na][1]+aAtuSD1[Na][2]+aAtuSD1[Na][3]+aAtuSD1[Na][4]+aAtuSD1[Na][5]+aAtuSD1[Na][6]))
			If SD1->(FieldPos("D1_CRPRESC"))>0
				RecLock("SD1",.F.)
				SD1->D1_CRPRESC := aAtuSD1[Na][7]
				MsUnlock()
			EndIf
		Endif
	Next nA
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grava a tabela de apontamento do SIGAPMS                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For ny := 1 to Len(aAmarrAFN)
		For nw := 1 to Len(aAmarrAFN[ny])
			If aAmarrAFN[nY][nW][6] > 0
				RecLock("AFN",.T.)
				AFN->AFN_FILIAL := xFilial("AFN")
				AFN->AFN_PROJET := aAmarrAFN[nY][nW][1]
				AFN->AFN_REVISA := aAmarrAFN[nY][nW][2]
				AFN->AFN_TAREFA := aAmarrAFN[nY][nW][3]
				AFN->AFN_QUANT  := 1
				AFN->AFN_DOC    := cNfFrete
				AFN->AFN_SERIE  := cSeFrete
				AFN->AFN_FORNEC := cForFrete
				AFN->AFN_LOJA   := cLojFrete
				AFN->AFN_ITEM   := aAmarrAFN[ny][nw][8]
				AFN->AFN_TIPONF := cTipo
				AFN->AFN_COD    := aAmarrAFN[ny][nw][9]
				MsUnlock()
				
				// busca pela nota de entrada q está gerando o frete
				If (nPos := aScan( aSD1Vlr ,{|x| x[1] == cNfFrete .and. x[2] == cSeFrete .and. x[3] == cForFrete .and. x[4] == cLojFrete .and. x[5] == aAmarrAFN[nY][nW][9] }))>0
					// calcula o percentual a ser rateado pro projeto e tarefa
					nInd := NoRound(aAmarrAFN[nY][nW][6]/aAmarrAFN[nY][nW][7]*100,nDecAFN)/100
				Else
					nInd := 0
				Endif
				
				SD1->(dbSetOrder(1))
				If SD1->(MsSeek(xFilial("SD1")+cNfFrete + cSeFrete + cForFrete + cLojFrete + aAmarrAFN[nY][nW][9] ))
					aCusto := { NoRound( SD1->D1_CUSTO*nInd  ,nDecSD1 ) ;
					,NoRound( SD1->D1_CUSTO2*nInd ,nDecSD1 ) ;
					,NoRound( SD1->D1_CUSTO3*nInd ,nDecSD1 ) ;
					,NoRound( SD1->D1_CUSTO4*nInd ,nDecSD1 ) ;
					,NoRound( SD1->D1_CUSTO5*nInd ,nDecSD1 ) }
				EndIf
				PmsAvalAFN("AFN",1,.T.,aCusto)
			EndIf
		Next nw
	Next ny
Else
	For nX	:= 1 to Len(aRecSF8)
		dbSelectArea("SF8")
		MsGoto(aRecSF8[nX])
		dbSelectArea("SF1")
		dbClearFilter()
		dbSetOrder(1)
		
		// Guardo as informacoes nota fiscal original
		If SF1->(dbSeek(xFilial("SF1")+SF8->F8_NFORIG+SF8->F8_SERORIG+SF8->F8_FORNECE+SF8->F8_LOJA+"N")) .Or.;
			SF1->(dbSeek(xFilial("SF1")+SF8->F8_NFORIG+SF8->F8_SERORIG+SF8->F8_FORNECE+SF8->F8_LOJA+"D"))
			
			Reclock("SF1",.F.,.T.)
			SF1->F1_ORIGLAN   := If(SF1->F1_ORIGLAN=="FD"," D","  ")
			MsUnlock()
			
			nLimAtu := 0
			
			dbSelectArea("SD1")
			dbClearFilter()
			dbSetOrder(1)
			MsSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
			While ( !Eof() .And. SD1->D1_FILIAL  == xFilial("SD1")  .And.;
				SD1->D1_DOC     == SF1->F1_DOC     .And.;
				SD1->D1_SERIE   == SF1->F1_SERIE   .And.;
				SD1->D1_FORNECE == SF1->F1_FORNECE .And.;
				SD1->D1_LOJA    == SF1->F1_LOJA )
				
				RecLock("SD1",.F.,.T.)
				SD1->D1_ORIGLAN   := IIF(SD1->D1_ORIGLAN=="FD"," D","  ")
				If (FieldPos("D1_CRPRESC"))>0 .And. Len(aAtuExc)>0
					If (nY := aScan( aAtuExc, {|x| x[1] == SF8->F8_NFDIFRE .And. x[2] == SF8->F8_SEDIFRE .And. x[3] == SF8->F8_FORNECE .And. x[4] == SF8->F8_LOJA .And. x[5] == SD1->D1_COD .And. x[6] == SD1->D1_ITEM })) > 0
						SD1->D1_CRPRESC   -= aAtuExc[nY][7] //deduzo o valor do credito presumido do item do conhecimento
						nLimAtu 			+= aAtuExc[nY][7]
					Endif
				EndIf
				MsUnlock()
				
				dbSelectArea("SD1")
				dbSkip()
			EndDo
			If nLimAtu > 0
				dbSelectArea("SF3")
				SF3->(dbClearFilter())
				SF3->(dbSetOrder(4))
				MsSeek(xFilial("SF3")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_DOC+SF1->F1_SERIE)
				While ( !Eof() .And.  SF3->F3_FILIAL  == xFilial("SF3") .And.;
					SF3->F3_NFISCAL == SF1->F1_DOC    .And.;
					SF3->F3_SERIE   == SF1->F1_SERIE  .And.;
					SF3->F3_CLIEFOR == SF1->F1_FORNECE.And.;
					SF3->F3_LOJA    == SF1->F1_LOJA )
					
					RecLock("SF3",.F.,.T.)
					If SF3->(FieldPos("F3_CRDPRES"))>0
						SF3->F3_CRDPRES -= nLimAtu
					EndIf
					MsUnlock()
					dbSelectArea("SF3")
					dbSkip()
				EndDo
				
				dbSelectArea("SFT")
				SFT->(dbClearFilter())
				SFT->(dbSetOrder(3))
				MsSeek(xFilial("SFT")+"E"+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_SERIE+SF1->F1_DOC)
				While ( !Eof() .And. SFT->FT_FILIAL  == xFilial("SFT") .And.;
					SFT->FT_NFISCAL == SF1->F1_DOC    .And.;
					SFT->FT_SERIE   == SF1->F1_SERIE  .And.;
					SFT->FT_CLIEFOR == SF1->F1_FORNECE.And.;
					SFT->FT_LOJA    == SF1->F1_LOJA )
					
					RecLock("SFT",.F.,.T.)
					If SFT->(FieldPos("FT_CRDPRES"))>0
						SFT->FT_CRDPRES -= nLimAtu
					EndIf
					MsUnlock()
					dbSelectArea("SFT")
					dbSkip()
				EndDo
			EndIf
		Endif
		dbSelectArea("SF8")
		RecLock("SF8",.F.,.T.)
		dbDelete()
		MsUnlock()
	Next
	dbSelectArea("SF1")
EndIf
RestArea(aArea)
RestArea(aAreaSF1)
RestArea(aAreaSD1)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A116VldExc³ Autor ³ Edson Maricate        ³ Data ³07.01.2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Verifica se a NF pode ser excluida.                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MATA116                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function A116VldExc(nRecSF1,aRecSC5)

Local lRet		:= .F.
Local lRetPE	:= .F.
Local l100DelT	:= ExistTemplate('A100DEL')
Local lIntACD	:= SuperGetMV("MV_INTACD",.F.,"0") == "1"
Local l100Del	:= ExistBlock('A100DEL')
Local dDataFec	:= If(FindFunction("MVUlmes"),MVUlmes(),GetMV("MV_ULMES"))

dbSelectArea("SF1")
dbGoto(nRecSF1)

Do Case
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Nao excluir NF nao classificada                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Case Empty(SF1->F1_STATUS)
		HELP(" ",1,"A100NOCLAS")
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verificar data do ultimo fechamento em SX6                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Case dDataFec>=dDataBase .Or. dDataFec>=SF1->F1_DTDIGIT
		Help( " ", 1, "FECHTO" )
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica ultima data para operacoes fiscais                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Case !FisChkExc(SF1->F1_SERIE,SF1->F1_DOC,SF1->F1_FORNECE,SF1->F1_LOJA)
		lRet := .F.
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Ponto de entrada para permitir ou nao a exclusao             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Case l100DelT .And. ;
		ValType(lRetPE := ExecTemplate("A100DEL",.F.,.F.) ) == "L" .And. ! lRetPE
		lRet := .F.
		
	Case l100Del .And. ;
		ValType(lRetPE := Execblock("A100DEL",.F.,.F.) ) == "L" .And. ! lRetPE
		lRet := .F.
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Chamada para integracao com o modulo ACD		  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Case lIntACD .And. FindFunction("CBA100DEL") .And. !(CBA100DEL())
		lRet := .F.
	OtherWise
		lRet := .T.
EndCase

Return lRet


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A116GetSF8³ Autor ³ Bruno Sobieski        ³ Data ³22.07.2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Pega os registros do SF8 referentes a nota fiscal atual     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MATA116,LOCXNF (NAO DEFINIR COMO STATIC!!!)                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function A116GetSF8(lContinua)

Local aRet	:=	{}

dbSelectArea("SF8")
dbSetOrder(1)
MsSeek(xFilial("SF8")+SF1->F1_DOC+SF1->F1_SERIE)
Do While !Eof() .And. xFilial("SF8")+SF1->F1_DOC+SF1->F1_SERIE == F8_FILIAL+F8_NFDIFRE+F8_SEDIFRE .And. lContinua
	If xFilial("SF8")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA  != F8_FILIAL+F8_NFDIFRE+F8_SEDIFRE+F8_TRANSP+F8_LOJTRAN
		dbSkip()
		Loop
	EndIf
	If !SoftLock("SF8")
		lContinua	:= .F.
	EndIf
	aadd(aRet,RecNo())
	dbSkip()
End

Return aRet


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A116ChkTES³ Autor ³ Nereu Humberto Junior ³ Data ³05.11.2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Verifica se o TES digitado e de entrada.                    ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Codigo do TES                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL: Validacao do Tipo de Entrada/Saida (TES)              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MATA116                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function A116ChkTES(cCodTES)

Local lRet := .T.
If SubStr(cCodTES,1,1) >= "5" .And. cCodTES <> "500"
	HELP("   ",1,"INV_TE")
	lRet := .F.
Endif

Return (lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A116CredP ³ Autor ³ Luciana Pires         ³ Data ³29.04.2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Verifica os creditos presumidos na exclusão do conhec. frete³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA116                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A116CredP(l116Exclui,aRecSF8)

Local aArea	    := GetArea()
Local nX        := 0
Local cMvEstado := SuperGetMV("MV_ESTADO")
Local aAtuExc	:= {}

If l116Exclui
	For nX	:= 1 to Len(aRecSF8)
		dbSelectArea("SF8")
		MsGoto(aRecSF8[nX])
		dbSelectArea("SF1")
		dbClearFilter()
		dbSetOrder(1)
		// Guardo as informacoes credito presumido SC - nota conhecimento de frete
		If cMvEstado=="SC" .And. SD1->(FieldPos("D1_CRPRESC"))>0 .And. SF4->(FieldPos("F4_CRDPRES"))>0
			If SF1->(dbSeek(xFilial("SF1")+SF8->F8_NFDIFRE+SF8->F8_SEDIFRE+SF8->F8_TRANSP+SF8->F8_LOJTRAN+"C"))
				
				dbSelectArea("SD1")
				dbClearFilter()
				dbSetOrder(1)
				MsSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
				While ( !SD1->(Eof()) .And. SD1->D1_FILIAL == xFilial("SD1") .And.;
					SD1->D1_DOC    	== SF1->F1_DOC     .And.;
					SD1->D1_SERIE  	== SF1->F1_SERIE   .And.;
					SD1->D1_FORNECE	== SF1->F1_FORNECE .And.;
					SD1->D1_LOJA   	== SF1->F1_LOJA )
					
					//Alimento o array com os valores dos creditos presumidos calculados, para atualizar
					//depois nos itens do conhecimento de frete.
					If SD1->D1_CRPRESC > 0
						AAdd(aAtuExc, {SD1->D1_DOC,;   			//1
						SD1->D1_SERIE,; 		//2
						SD1->D1_FORNECE,; 		//3
						SD1->D1_LOJA,;    		//4
						SD1->D1_COD,;     		//5
						SD1->D1_ITEM,;     		//6
						SD1->D1_CRPRESC})		//7
						//Depois de guardar para deduzir da nota original, eu zero o valor do credito do item do
						//conhecimento de frete
						RecLock("SD1",.F.)
						SD1->D1_CRPRESC   := 0
						MsUnlock()
					Endif
					SD1->(dbSkip())
				EndDo
			Endif
		Endif
	Next
EndIf
RestArea(aArea)

Return(aAtuExc)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³a116CDAOk ³ Autor ³ Microsiga SA          ³ Data ³31/05/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao para validar a linha do acols de lancamentos         ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T. ou .F.                                                  ³±±
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
Static Function a116CDAOk()

Local	lRet	:=	.T.
Local	nPosLanc:=	0
Local	nPosVlr	:=	0
Local	nNumIte	:=	0

If Type("oLancApICMS")=="O"
	nPosLanc:=	aScan(oLancApICMS:aHeader,{|aX|aX[2]=="CDA_CODLAN"})
	nPosVlr:=	aScan(oLancApICMS:aHeader,{|aX|aX[2]=="CDA_VALOR"})
	nNumIte:=	aScan(oLancApICMS:aHeader,{|aX|aX[2]=="CDA_NUMITE"})
	
	If !oLancApICMS:aCols[oLancApICMS:nAT,Len(oLancApICMS:aCols[oLancApICMS:nAT])] .And.;
		!Empty(oLancApICMS:aCols[oLancApICMS:nAT,nNumIte])
		
		If nPosLanc>0 .And. Empty(oLancApICMS:aCols[oLancApICMS:nAT,nPosLanc])
			Help(1," ","OBRIGAT",,"CDA_CODLAN"+Space(30),3,0)
			lRet	:=	.F.
		EndIf
		
		If lRet .And. nPosLanc>0 .And. Empty(oLancApICMS:aCols[oLancApICMS:nAT,nPosVlr])
			Help(1," ","OBRIGAT",,"CDA_VALOR"+Space(30),3,0)
			lRet	:=	.F.
		EndIf
	EndIf
EndIf
Return lRet



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A116CpXml ºAutor  ³Leandro Paulino   	 º Data ³  07/12/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Complementa o Xml recebido pelo EAI para preenchimento das º±±
±±º          ³ chaves primaria do protheus								  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Integracao OMS x GFE                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A116CpXml()

Local cRet    		:= PARAMIXB[1]
Local aArea			:= GetArea()
Local oXml	 		:= Nil
Local lRet        	:= .F.
Local cCGCForSF1	:= ""
Local cCGCForSF8	:= ""
Local cCgcTraSF8	:= ""
Local nTotReg 		:= 0
Local nRegAtu 		:= 1

RestArea(aArea)
Return cRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³a116Mark  ³ Autor ³ Aline S Damasceno     ³ Data ³26/01/2012³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao para validar as NF marcadas						  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function a116Mark()

Local lM116MARK := ExistBlock('M116MARK')
Local aArea     := GetArea()
Local cMark		:= ThisMark()

RecLock("SF1",.F.)
If IsMark('F1_OK',cMark)
	SF1->F1_OK :=Space(2)
Else
	SF1->F1_OK :=cMark
EndIf
MsUnLock()
MarkBRefresh()

RestArea(aArea)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A116IGrava³ Autor ³ Rodrigo Toledo Silva  ³ Data ³25.05.2012	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Faz a inclusao de registros na tabela SDT apos o calculo   	³±±
±±³ 		 ³ do valor de rateio do conhecimento de transporte.		  	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpA1 -> Array com os elementos dos itens da nf de entrada  	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MATA116I - Importacao de arquivos XML Ct-e (TOTVS Colaboracao)³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function A116IGrava(aNFItens)

Local aArea	   := SDT->(GetArea())
Local nX 	   := 0

SA5->(dbSetOrder(1))
SDT->(dbSetOrder(2))

For nX := 1 To Len(aNFItens)
	RecLock("SDT",.T.)
	SDT->DT_FILIAL	:= xFilial("SDT")								// Filial
	SDT->DT_ITEM	:= aNFItens[nX,GDFieldPos("D1_ITEM")]			// Item
	SDT->DT_COD		:= aNFItens[nX,GDFieldPos("D1_COD")]			// Codigo do produto
	SDT->DT_FORNEC	:= SDS->DS_FORNEC								// Fornecedor do conhecimento de frete
	SDT->DT_LOJA	:= SDS->DS_LOJA									// Loja do fornecedor do conhecimento
	SDT->DT_DOC		:= SDS->DS_DOC	 								// Numero do conhecimento de frete
	SDT->DT_SERIE	:= SDS->DS_SERIE								// Serie do conhecimento de frete
	SDT->DT_CNPJ	:= SDS->DS_CNPJ									// CNPJ/CPF do fornecedor do conhecimento
	SDT->DT_VUNIT	:= aNFItens[nX,GDFieldPos("D1_VUNIT")]	 		// Valor unitario
	SDT->DT_TOTAL	:= aNFItens[nX,GDFieldPos("D1_TOTAL")]			// Valor total
	If SDT->(FieldPos("DT_NFORI")) > 0
		SDT->DT_NFORI	:= aNFItens[nX,GDFieldPos("D1_NFORI")]	 	// Nota fiscal original
		SDT->DT_SERIORI	:= aNFItens[nX,GDFieldPos("D1_SERIORI")] 	// Serie da nota fiscal original
		SDT->DT_ITEMORI	:= aNFItens[nX,GDFieldPos("D1_ITEMORI")] 	// Item da nota fiscal original
	EndIf
	SDT->(MsUnlock())
Next nX

SDT->(RestArea(aArea))
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FillCTBEntºAutor  ³ Anieli Rodrigues	 º Data ³ 15/05/13    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Inicaliza campos das entidades contabeis de acordo com a   º±±
±±º          ³ origem.                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATA116                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FillCTBEnt(cOrigem,nItem)
Local aCTBEnt := If(FindFunction("CTBEntArr"),CTBEntArr(),{})
Local nX	  := 0

For nX := 1 To Len(aCTBEnt)
	If GDFieldPos("D1_EC"+aCTBEnt[nX]+"CR",aHeader) > 0
		aCols[nItem,GDFieldPos("D1_EC"+aCTBEnt[nX]+"CR")] := (cOrigem)->&("D1_EC"+aCTBEnt[nX]+"CR")
	EndIf
	If GDFieldPos("D1_EC"+aCTBEnt[nX]+"DB",aHeader) > 0
		aCols[nItem,GDFieldPos("D1_EC"+aCTBEnt[nX]+"DB")] := (cOrigem)->&("D1_EC"+aCTBEnt[nX]+"DB")
	EndIf
Next nX

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MenuDef   ³ Autor ³ Materiais       ³ Data ³01/11/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Utilizacao de menu Funcional                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function MenuDef()

Private aRotina := {}

aAdd(aRotina,{OemtoAnsi(STR0002),"PesqBrw"    ,0,1}) //"Pesquisar"
aAdd(aRotina,{OemtoAnsi(STR0003),"A103NFiscal",0,2}) //"Visualizar"

If !(Type("nRotina") == "U")
	If nRotina == 1
		aadd(aRotina,{OemtoAnsi(STR0004),"A116Inclui",0,5}) //"Excluir"
		lInclui := .F.
	Else
		aadd(aRotina,{OemtoAnsi(STR0005),"A116Inclui",0,6}) //"Gera Conhec."
	End
EndIf

Return(aRotina)