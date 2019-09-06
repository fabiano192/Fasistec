#INCLUDE 'TOTVS.CH'

/*
Programa	: CR0037
Autor		: Fabiano da Silva
Data		: 02/08/2013
Descrição	: Gravar Data do Embarque
*/

User Function CR0037()

	LOCAL oDlg := NIL

	PRIVATE cTitulo    	:= "Atualiza Data de Embarque"
	PRIVATE oPrn       	:= NIL
	PRIVATE oFont2     	:= NIL
	PRIVATE oFont5     	:= NIL

	_nOpc := 0

	AtuSx1()

	DEFINE FONT oFont2 NAME "Arial" SIZE 0,13 OF oPrn BOLD
	DEFINE FONT oFont5 NAME "Arial" SIZE 0,10 OF oPrn BOLD

	DEFINE MSDIALOG oDlg FROM 264,182 TO 441,613 TITLE cTitulo OF oDlg PIXEL

	@ 004,010 TO 060,157 LABEL "" OF oDlg PIXEL

	@ 010,017 SAY "Esta rotina tem por objetivo Atualizar a  " OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
	@ 020,017 SAY "Data de Embarque do Processo conforme os  " OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
	@ 030,017 SAY "parametros informados pelo usuário.       " OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
	@ 050,017 SAY "Programa CR0037.PRW                       " OF oDlg PIXEL Size 150,010 FONT oFont5 COLOR CLR_RED

	@ 70,020 BUTTON "Parametros" SIZE 036,012 ACTION ( Pergunte("CR0037"))	OF oDlg PIXEL
	@ 70,090 BUTTON "OK" 		 SIZE 036,012 ACTION (_nOpc:=1,oDlg:End()) 	OF oDlg PIXEL
	@ 70,160 BUTTON "Sair"       SIZE 036,012 ACTION ( oDlg:End()) 			OF oDlg PIXEL

	ACTIVATE MSDIALOG oDlg CENTERED

	If _nOpc == 1
		Proces()
	Endif

Return


Static Function Proces()

	Pergunte("CR0037",.F.)

	Private _lFim      := .F.
	Private _cMsg01    := ''
	Private _lAborta01 := .T.
	Private _bAcao01   := {|_lFim| CR037A(@_lFim) }
	Private _cTitulo01 := 'Processando'
	Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

Return


Static Function CR037A(_lFim)

	EEC->(dbSetOrder(1))
	If EEC->(dbSeek(xFilial("EEC")+MV_PAR01))
		EEC->(RecLock("EEC",.f.))
		EEC->EEC_DTEMBA  := MV_PAR02
		EEC->EEC_FIM_PE  := MV_PAR02
		If !Empty(MV_PAR02)
			EEC->EEC_STATUS  := "6"
			EEC->EEC_STTDES  := "Embarcado"
		Else
			EEC->EEC_STATUS  := "4"
			EEC->EEC_STTDES  := "Aguardando Confeccao Documentos"
		Endif
		EEC->(MsUnlock())
		Msginfo("Data de Embarque inserida com sucesso!")
	Else
		Alert("Processo nao encontrado!")
	Endif

Return



Static Function AtuSX1()

	cPerg := "CR0037"

///////////////////////////////////////
////   MV_PAR01  : Processo ?		///
////   MV_PAR02  : Data Embarque    ///
//////////////////////////// //////////

//    	   Grupo/Ordem/Pergunta               /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid	/Var01      /Def01    	/defspa1/defeng1/Cnt01/Var02/Def02			/Defspa2/defeng2/Cnt02/Var03/Def03		/defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
	U_CRIASX1(cPerg,"01","Processo		 		?",""       ,""      ,"mv_ch1","C" ,20     ,0      ,0     ,"G",""        ,"MV_PAR01",""	 	 	,""     ,""     ,""   ,""   ,""				,""     ,""     ,""   ,""   ,""  		,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
	U_CRIASX1(cPerg,"02","Data Embarque         ?",""       ,""      ,"mv_ch2","D" ,08     ,0      ,0     ,"G",""        ,"MV_PAR02",""        	,""     ,""     ,""   ,""   ,""     		,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")

Return
