#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
Programa PA0212
Autor 		: Alison de Oliveira	-	20/07/10
Uso 		: SIGAGPE - Gestão Pessoal
Descrição 	: Gerar relatório de Dados dos Funcionários
*/

USER FUNCTION PA0212()

LOCAL oDlg := NIL

PRIVATE cTitulo    	:= "RELATÓRIO DE DADOS DOS FUNCIONÁRIOS"
PRIVATE oPrn       	:= NIL
PRIVATE oFont2     	:= NIL
PRIVATE oFont5     	:= NIL

DEFINE FONT oFont2 NAME "Arial" SIZE 0,13 OF oPrn BOLD
DEFINE FONT oFont5 NAME "Arial" SIZE 0,10 OF oPrn BOLD

DEFINE MSDIALOG oDlg FROM 264,182 TO 441,613 TITLE cTitulo OF oDlg PIXEL
@ 004,010 TO 082,157 LABEL "" OF oDlg PIXEL

@ 010,017 SAY "Esta rotina tem por objetivo gerar o relatório  " OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
@ 020,017 SAY "de Dados dos Funcionários conforme os parâmetros" OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
@ 030,017 SAY "informados pelo usuário.                        " OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
@ 040,017 SAY "                                                " OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
@ 060,017 SAY "                                                " OF oDlg PIXEL Size 150,010 FONT oFont5 COLOR CLR_RED
@ 070,017 SAY "Programa PA0212.PRW                             " OF oDlg PIXEL Size 150,010 FONT oFont5 COLOR CLR_RED


@ 35,167 BUTTON "Parametros" SIZE 036,012 ACTION ( Pergunte("PA0212"))	OF oDlg PIXEL
@ 50,167 BUTTON "OK" 		 SIZE 036,012 ACTION (PA212A(),oDlg:End()) 	OF oDlg PIXEL
@ 65,167 BUTTON "Sair"       SIZE 036,012 ACTION ( oDlg:End()) 			OF oDlg PIXEL

ACTIVATE MSDIALOG oDlg CENTERED

Return(Nil)

SRA->(dbSetOrder(1))

Static Function PA212A()

Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| PA212B(@_lFim) }
Private _cTitulo01 := 'Processando'

Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )


_cArqNovo := "\SPOOL\PA0212.DBF"
dbSelectArea("TRB")
Copy all to &_cArqNovo

TRB->(dbCloseArea())

If ! ApOleClient( 'MsExcel' )
	MsgStop('MsExcel nao instalado')
	Return
EndIf

oExcelApp := MsExcel():New()
oExcelApp :WorkBooks:Open( "\\SERVER2\ERP\PROTHEUS11\PROTHEUS_DATA\spool\PA0212.DBF" ) // Abre uma planilha
oExcelApp :SetVisible(.T.)


Return(Nil)

Static Function PA212B()

Pergunte("PA0212",.F.)

aStru := {}
AADD(aStru,{"NOME"          , "C" , 60 , 0 })
AADD(aStru,{"MATRIC"        , "C" , 06 , 0 })
AADD(aStru,{"ADMISS"        , "D" , 12 , 0 })
AADD(aStru,{"SITFOL"        , "C" , 02 , 0 })
AADD(aStru,{"SALARI"        , "N" , 14 , 2 })
AADD(aStru,{"TPSALA" 	    , "C" , 02 , 0 })
AADD(aStru,{"CODFUNC"       , "C" , 06 , 0 })
AADD(aStru,{"DESC"   	    , "C" , 20 , 0 })
AADD(aStru,{"TURNO"         , "C" , 04 , 0 })
AADD(aStru,{"DESCTUR" 	    , "C" , 50 , 0 })

cArqLOG := CriaTrab(aStru,.T.)
cIndLOG := "NOME+MATRIC"
dbUseArea(.T.,,cArqLOG,"TRB",.F.,.F.)

dbSelectArea("TRB")
IndRegua("TRB",cArqLog,cIndLog,,,"Criando Trabalho...")

SRA->(dbSetOrder(1))
SRA->(dbGoTop())

//ProcRegua(LastRec())

While SRA->(!EOF())
	//	IncProc()
	
	If  (SRA->RA_MAT < MV_PAR01 .OR. SRA->RA_MAT > MV_PAR02)     .OR.;
		(SRA->RA_NOME < MV_PAR03 .OR. SRA->RA_NOME > MV_PAR04)   .OR.;
		(!EMPTY(SRA->RA_DEMISSA))
		SRA->(DBSKIP())
		LOOP
	Endif
	
	_Funcao :=""
	
	SRJ->(DBSETORDER(1))
	IF SRJ->(DBSEEK(XFILIAL("SRJ")+SRA->RA_CODFUNC))
		_cFuncao :=SRJ->RJ_DESC
    Endif
       
    _cTurno :=""
    
	SR6->(DBSETORDER(1))
	IF SR6->(DBSEEK(XFILIAL("SR6")+SRA->RA_TNOTRAB))
		_cTurno :=SR6->R6_DESC
	Endif
	
	TRB->(RecLock("TRB",.T.))
	
	TRB->NOME       := SRA->RA_NOME
	TRB->MATRIC     := SRA->RA_MAT
	TRB->ADMISS     := SRA->RA_ADMISSA
	TRB->SITFOL     := SRA->RA_SITFOLH
	TRB->SALARI     := SRA->RA_SALARIO
	TRB->TPSALA     := SRA->RA_TIPOPGT
	TRB->CODFUNC    := SRA->RA_CODFUNC
    TRB->DESC       := _cFuncao
	TRB->TURNO      := SRA->RA_TNOTRAB
	TRB->DESC       := _cTurno
	TRB->(MsUnlock())
	
	SRA->(dbSkip()) // Avanca o ponteiro do registro no arquivo
EndDo


Return (Nil)
