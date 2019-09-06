#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Rotina   ³ PA0167                                   ³ Data ³ 14/11/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Rotina para Exportacao de Pedidos Cronnos                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Módulo   ³ SigaFat                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PA0167()

ATUSX1()

_lImp := .F.
_nOpc := 0
@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Rotina Para Exportacao Pedidos")
@ 02,10 TO 080,220
@ 10,18 SAY "Rotina de Exportacao  dos Pedidos de Venda Cadastra-"     SIZE 160,7
@ 18,18 SAY "dos na Pasy e enviado para Cronnos.      Via E-mail "     SIZE 160,7
@ 26,18 SAY "Arquivos que Estarão salvos   no Diretorio          "     SIZE 160,7
@ 34,18 SAY "\MP_DATA\PEDIDOS\EXPORTACAO.    PROGRAMA PA0167.PRW "     SIZE 160,7

@ 85,128 BMPBUTTON TYPE 5 ACTION Pergunte("PA0167")
@ 85,158 BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())
@ 85,188 BMPBUTTON TYPE 2 ACTION oDlg:END()

Activate Dialog oDlg Centered

If _nOpc == 1
	Private _cMsg01    := ''
	Private _lFim      := .F.
	Private _lAborta01 := .T.
	Private _bAcao01   := {|_lFim| Proc2(@_lFim) }
	Private _cTitulo01 := 'Exportando Pedidos !!!!'
	Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
Endif

Return



Static Function Proc2(_lfim)

Pergunte("PA0167",.F.)
                  
_lInteg  := .F.
_cDia    := Dtos(dDataBase)
_cHora   := Substr(Time(),1,2) + Substr(Time(),4,2)

_cTabSC5 := "SC5CRON"
_aStru   := SC5->(dbStruct())
dbCreate(_cTabSC5,_aStru,"DBFCDX")
dbUseArea(.t.,"DBFCDX",_cTabSC5,"ZC5",.T.,.F.)

_cTabSC6 := "SC6CRON"
_aStru   := SC6->(dbStruct())
dbCreate(_cTabSC6,_aStru,"DBFCDX")
dbUseArea(.t.,"DBFCDX",_cTabSC6,"ZC6",.T.,.F.)

_cArqSC5   := "\PEDIDOS\EXPORTACAO\SC5"+_cDia+".DBF"
_cArqSC6   := "\PEDIDOS\EXPORTACAO\SC6"+_cDia+".DBF"
_cArqSC5B  := "\PEDIDOS\EXPORTACAO\BKP\SC5"+_cDia+_cHora+".DBF"
_cArqSC6B  := "\PEDIDOS\EXPORTACAO\BKP\SC6"+_cDia+_cHora+".DBF"

_aCampC5   := {}
_aCampC6   := {}

SC5->(dbSetOrder(2))
SC5->(dbSeek(xFilial("SC5")+DTOS(MV_PAR01),.T.))

While SC5->(!Eof()) .And. SC5->C5_EMISSAO <= MV_PAR02 .And. !_lFim
	
	If _lFim
		Return
	Endif
	
	If Empty(SC5->C5_CLIENT)
		SC5->(dbSkip())
		Loop
	Endif
	                          
	If SC5->C5_CLIENTE != "000252"
		SC5->(dbSkip())
		Loop
	Endif
	
	_lInteg := .T.
	_aCampC5   := {}
	
	dbSelectArea("SC5")
	For _W := 1 To FCount()
		AADD(_aCampC5,{FieldName(_W),FieldGet(_W)})
	Next
	
	dbSelectArea("ZC5")
	RecLock("ZC5",.T.)
	For _W:= 1 to Len(_aCampC5)
		_nPos := FieldPos(_aCampC5[_W,1])
		FieldPut(_nPos,_aCampC5[_W,2])
	Next
	MsUnlock()
	
	SC5->(RecLock("SC5",.F.))
	SC5->C5_INTEGR := "S"
	SC5->(MsUnlock())
	
	SC6->(dbSetOrder(1))
	If SC6->(dbSeek(xFilial("SC6")+SC5->C5_NUM))
		
		_cPed := SC5->C5_NUM
		
		While SC6->(!Eof()) .And. _cPed == SC6->C6_NUM .And. !_lFim
			
			If _lFim
				Return
			Endif
			
			_aCampC6   := {}
			dbSelectArea("SC6")
			For _W := 1 To FCount()
				AADD(_aCampC6,{FieldName(_W),FieldGet(_W)})
			Next
			
			dbSelectArea("ZC6")
			RecLock("ZC6",.T.)
			For _W:= 1 to Len(_aCampC6)
				_nPos := FieldPos(_aCampC6[_W,1])
				FieldPut(_nPos,_aCampC6[_W,2])
			Next
			MsUnlock()
			
			SC6->(dbSkip())
		EndDo
	Endif
	
	SC5->(dbSkip())
EndDo

If _lInteg
	dbSelectArea("ZC5")
	COPY ALL TO &_cArqSC5
	dbSelectArea("ZC5")
	COPY ALL TO &_cArqSC5B
	
	dbSelectArea("ZC6")
	COPY ALL TO &_cArqSC6
	
	dbSelectArea("ZC6")
	COPY ALL TO &_cArqSC6B
Endif


Return


Static Function AtuSX1()

cPerg := "PA0167"

///////////////////////////////////////
////   MV_PAR01  : Data De          ///
////   MV_PAR02  : Data Ate         ///
///////////////////////////////////////

//    	   Grupo/Ordem/Pergunta               /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01           /Def01    	/defspa1/defeng1/Cnt01/Var02/Def02/Defspa2/defeng2/Cnt02/Var03/Def03/defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
U_CRIASX1(cPerg,"01","Data De               ?",""       ,""      ,"mv_ch1","D" ,08     ,0      ,0     ,"G",""        ,"MV_PAR01",""        	,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"02","Data Ate              ?",""       ,""      ,"mv_ch2","D" ,08     ,0      ,0     ,"G",""        ,"MV_PAR02",""        	,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")

Return