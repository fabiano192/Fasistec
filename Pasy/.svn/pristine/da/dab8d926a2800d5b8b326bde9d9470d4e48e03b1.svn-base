#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณACEDIVER  บ Autor ณ Alexandro da Silva บ Data ณ  06/03/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Atualiza็ao Produto X Cliente                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SigaFat                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function PA0163()

ATUSX1()


_nOpc := 0
@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Libera็ใo Automatica da Produ็ao (C.Q.) - PA0163")
@ 02,10 TO 080,220
@ 10,18 SAY "Rotina Para Efetuar a Libera็ใo Dos Itens de Produ- "     SIZE 160,7
@ 18,18 SAY "็ao enviados para o C.Q., conforme parametros infor-"     SIZE 160,7
@ 26,18 SAY "mados pelo Usuario                                  "     SIZE 160,7
@ 34,18 SAY "Programa PA0163.PRW                                 "     SIZE 160,7

@ 85,128 BMPBUTTON TYPE 5 ACTION Pergunte("PA0163")
@ 85,158 BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())
@ 85,188 BMPBUTTON TYPE 2 ACTION oDlg:END()

ACTIVATE DIALOG oDlg Centered

If _nOpc == 1
	
	Pergunte("PA0163",.F.)
	
	If MV_PAR01 < GETMV("MV_ULMES")
		MsgInfo("A Data ้ Inferior a Data do Fechamento de Estoque!!")
		Return
	Endif

	PUTMV("MV_ESTNEG","S")	
	Private _cMsg01    := ''
	Private _lFim      := .F.
	Private _lAborta01 := .T.
	Private _bAcao01   := {|_lFim| PA163_A(@_lFim) }
	Private _cTitulo01 := 'Selecionando Itens...!!!!'
	Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
	                        
	PUTMV("MV_ESTNEG","N")	

	MsgInfo("ATUALIZADO COM SUCESSO","INFO","INFORMACAO")
Endif

Return


Static Function PA163_A(_lFim)


_cQ := " SELECT D7_TIPO,D7_PRODUTO,D7_LOCAL,D7_SALDO,D7_NUMSEQ,D7_DATA,D7_SEQ,D7_NUMERO "
_cQ += " FROM "+RetSqlName("SD7")+" A WHERE A.D_E_L_E_T_ = '' AND D7_TIPO = 0 AND D7_SALDO > 0 "
_cQ += " AND D7_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND D7_ORIGLAN = 'PR' "
_cQ += " AND D7_PRODUTO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
_cQ += " ORDER BY D7_DATA,D7_PRODUTO "

TCQUERY _cQ NEW ALIAS "ZZ"

TCSETFIELD("ZZ","D7_DATA","D")

ZZ->(dbGotop())

ProcRegua(ZZ->(U_CONTREG()))

While ZZ->(!Eof()) .And. !_lFim
	
	ZZ->(IncProc())
	
	_cNumero:= ZZ->D7_NUMERO
	_cNumCq := ZZ->D7_NUMSEQ
	_cProd  := ZZ->D7_PRODUTO
	_cLocal := ZZ->D7_LOCAL
	_cSeq   := ZZ->D7_SEQ
	_cTipo  := STR(D7_TIPO)
	
	SB1->(dbSetOrder(1))
	SB1->(dbSeek(xFilial("SB1")+ZZ->D7_PRODUTO + ZZ->D7_LOCAL))
	
	SD7->(dbSetOrder(2))
	If SD7->(dbSeek(xFilial("SD7") + _cNumero + _cProd + _cLocal + _cNumCq + _cTipo))
		
		aLibera     := {}
		lMsErroAuto := .F.
		
		aAdd(aLibera,{{"D7_TIPO",1     ,Nil},;  //D7_TIPO
		{"D7_PRODUTO" ,ZZ->D7_PRODUTO  ,Nil},;  //D7_PRODUTO
		{"D7_DATA"    ,ZZ->D7_DATA     ,Nil},;  //D7_DATA
		{"D7_QTDE"    ,ZZ->D7_SALDO    ,Nil},;  //D7_QTDE
		{"D7_OBS"     ,"PA0163"        ,Nil},;  //D7_OBS
		{"D7_QTSEGUM" ,0               ,Nil},;  //D7_QTSEGUM
		{"D7_MOTREJE" ,""              ,Nil},;  //D7_MOTREJE
		{"D7_LOCDEST" ,SB1->B1_LOCPAD  ,Nil},;  //D7_LOCDEST
		{"D7_SALDO"   ,0               ,Nil}})  //D7_SALDO
		
		MSExecAuto({|x,y| mata175(x,y)},aLibera,4) //4 - Liberacao/Rejeicao
		
		If lMsErroAuto
//			MOSTRAERRO()
//			ZZ->(dbCloseArea())
//			Return
		Endif
	Endif
	
	ZZ->(dbSkip())
EndDo

ZZ->(dbCloseArea())

Return

Static Function ATUSX1()

cPerg := "PA0163"
aRegs :={}

///////////////////////////////////////////////
///////////////////////////////////////////////
/////  Grupo de Pergunta PA0163          //////
/////  MV_PAR01 : Data De         ?      //////
/////  MV_PAR02 : Data Ate        ?      //////
/////  MV_PAR03 : Produto      De ?      //////
/////  MV_PAR04 : Produto     Ate ?      //////
///////////////////////////////////////////////
///////////////////////////////////////////////

//    	   Grupo/Ordem/Pergunta               /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid     /Var01     /Def01        /defspa1/defeng1/Cnt01/Var02/Def02  /Defspa2/defeng2/Cnt02/Var03/Def03/defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
U_CRIASX1(cPerg,"01","Emissao De            ?",""       ,""      ,"mv_ch1","D" ,08     ,0      ,0     ,"G",""        ,"MV_PAR01",""           ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"02","Emissao Ate           ?",""       ,""      ,"mv_ch2","D" ,08     ,0      ,0     ,"G",""        ,"MV_PAR02",""           ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"03","Produto De            ?",""       ,""      ,"mv_ch3","C" ,15     ,0      ,0     ,"G",""        ,"MV_PAR03",""           ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SB1")
U_CRIASX1(cPerg,"04","Produto Ate           ?",""       ,""      ,"mv_ch4","C" ,15     ,0      ,0     ,"G",""        ,"MV_PAR04",""           ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SB1")

Return