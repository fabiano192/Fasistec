#INCLUDE "PROTHEUS.CH"
//#INCLUDE "FONT.CH"
#INCLUDE "TOPCONN.CH"

/*
Programa PA0181
Autor 		: Fabiano da Silva	-	11/05/09
Uso 		: SIGAPCP - PCP
Descrição 	: Gerar Relatório de Demitidos
*/

USER FUNCTION PA0181()

LOCAL oDlg := NIL

PRIVATE cTitulo    	:= "RELATORIO DE RESCISAO"
PRIVATE oPrn       	:= NIL
PRIVATE oFont1     	:= NIL
PRIVATE oFont2     	:= NIL
PRIVATE oFont3     	:= NIL
PRIVATE oFont4     	:= NIL
PRIVATE oFont5     	:= NIL
PRIVATE oFont6     	:= NIL
PRIVATE _nCont     	:= 0

AtuSx1()

DEFINE FONT oFont1 NAME "Arial" SIZE 0,10 OF oPrn BOLD
DEFINE FONT oFont2 NAME "Arial" SIZE 0,13 OF oPrn BOLD
DEFINE FONT oFont3 NAME "Arial" SIZE 0,14 OF oPrn BOLD
DEFINE FONT oFont4 NAME "Arial" SIZE 0,10 OF oPrn
DEFINE FONT oFont5 NAME "Arial" SIZE 0,10 OF oPrn BOLD
DEFINE FONT oFont6 NAME "Courier New" BOLD

DEFINE MSDIALOG oDlg FROM 264,182 TO 441,613 TITLE cTitulo OF oDlg PIXEL
@ 004,010 TO 082,157 LABEL "" OF oDlg PIXEL

@ 010,017 SAY "Esta rotina tem por objetivo gerar o relatório  " OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
@ 020,017 SAY "de Rescisao conforme os parâmetros informados   " OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
@ 030,017 SAY "pelo usuário.             						" OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
@ 040,017 SAY "                                                 " OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
@ 060,017 SAY "                                                 " OF oDlg PIXEL Size 150,010 FONT oFont5 COLOR CLR_RED
@ 070,017 SAY "Programa PA0181.PRW                              " OF oDlg PIXEL Size 150,010 FONT oFont5 COLOR CLR_RED

@ 10,167 BUTTON "Parametros" SIZE 036,012 ACTION ( Pergunte("PA0181"))	OF oDlg PIXEL
@ 35,167 BUTTON "OK" 		 SIZE 036,012 ACTION (PA181A(),oDlg:End()) 	OF oDlg PIXEL
@ 60,167 BUTTON "Sair"       SIZE 036,012 ACTION ( oDlg:End()) 			OF oDlg PIXEL

ACTIVATE MSDIALOG oDlg CENTERED

Return(Nil)


Static Function PA181A()

Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| PA181B(@_lFim) }
Private _cTitulo01 := 'Processando'

Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

_cArqNovo := "\SPOOL\RH\PA0181.DBF"
dbSelectArea("TRB")
Copy all to &_cArqNovo

dbCloseArea()

If ! ApOleClient( 'MsExcel' )
	MsgStop('MsExcel nao instalado')
	Return
EndIf

oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open( "\\SERVER2\ERP\PROTHEUS11\PROTHEUS_DATA\spool\RH\PA0181.DBF" ) // Abre uma planilha
oExcelApp:SetVisible(.T.)

Return(Nil)


Static Function PA181B()

Pergunte("PA0181",.F.)

aStru := {}
AADD(aStru,{"GERACAO" 	, "D" ,  8, 0 })
AADD(aStru,{"PAGAMENTO"	, "D" ,  8, 0 })
AADD(aStru,{"MATRICULA" , "C" ,  6, 0 })
AADD(aStru,{"NOME" 		, "C" , 60, 0 })
AADD(aStru,{"FGTS_13O"	, "N" , 14, 2 })
AADD(aStru,{"FGTS_QUIT" , "N" , 14, 2 })
AADD(aStru,{"LIQ_RESCI" , "N" , 14, 2 })
	
cArqLOG := CriaTrab(aStru,.T.)
cIndLOG := "NOME"
dbUseArea(.T.,,cArqLOG,"TRB",.F.,.F.)
	
dbSelectArea("TRB")
IndRegua("TRB",cArqLog,cIndLog,,,"Criando Trabalho...")
	
private nQuant     	:= 1
private cProduto   	:= ""
private cQtd
Private aArray   	:= {}

_cQuery  := " SELECT RR_MAT,RA_NOME,RR_PD,RR_DATA,RR_DATAPAG,RR_VALOR FROM "+RetSqlName("SRR")+" RR (NOLOCK) "
_cQuery  += " INNER JOIN "+RetSqlName("SRA")+" RA (NOLOCK) ON RR_MAT = RA_MAT "
_cQuery  += " WHERE RR.D_E_L_E_T_ = '' AND RA.D_E_L_E_T_ = '' AND RR_TIPO3 = 'R' "
_cQuery  += " AND RR_DATA = '"+DTOS(MV_PAR01)+"' "
_cQuery  += " AND RR_DATAPAG = '"+DTOS(MV_PAR02)+"' "
_cQuery  += " AND RR_MAT BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
_cQuery  += " AND RR_PD IN ('157','159','428') "
_cQuery  += " ORDER BY RR_MAT,RR_PD"

TCQUERY _cQuery NEW ALIAS "ZRR"

TcSetField("ZRR","RR_DATA","D")
TcSetField("ZRR","RR_DATAPAG","D")

ZRR->(dbGoTop())

ProcRegua(LastRec())

While ZRR->(!EOF())

	IncProc()

	If TRB->(!dbSeek(ZRR->RA_NOME))
		RecLock("TRB",.T.)
		TRB->GERACAO	:= ZRR->RR_DATA
		TRB->PAGAMENTO	:= ZRR->RR_DATAPAG
		TRB->MATRICULA	:= ZRR->RR_MAT
		TRB->NOME		:= ZRR->RA_NOME
		If ZRR->RR_PD == '157'
			TRB->FGTS_13O 	:= ZRR->RR_VALOR
		ElseIf ZRR->RR_PD == '159'
			TRB->FGTS_QUIT 	:= ZRR->RR_VALOR
		ElseIf 	 ZRR->RR_PD == '428'
			TRB->LIQ_RESCI 	:= ZRR->RR_VALOR
		Endif
		MsUnlock()
	Else	
		RecLock("TRB",.F.)
		If ZRR->RR_PD == '157'
			TRB->FGTS_13O 	:= ZRR->RR_VALOR
		ElseIf ZRR->RR_PD == '159'
			TRB->FGTS_QUIT 	:= ZRR->RR_VALOR
		ElseIf 	 ZRR->RR_PD == '428'
			TRB->LIQ_RESCI 	:= ZRR->RR_VALOR
		Endif
		MsUnlock()
	Endif
	
	ZRR->(dbSkip())
EndDO

Return()


Static Function AtuSx1(cPerg)

Local aHelp := {}
cPerg       := "PA0181"

//            Texto do help em português        			 	, Inglês, Espanhol
AAdd(aHelp, {{"Data da Geracao da Rescisao"					}, {""} , {""}})
AAdd(aHelp, {{"Data do Pagamento"							}, {""} , {""}})
AAdd(aHelp, {{"Matricula Inicial"						}, {""} , {""}})
AAdd(aHelp, {{"Matricula Final"						}, {""} , {""}})
//AAdd(aHelp, {{"Informe qual o tipo do relatório à ser impresso"	}, {""} , {""}})

PutSx1(cPerg,"01","Dt Geracao    ?" ,"","","mv_ch1","D",08,00,00,"G","",""     ,"","","MV_PAR01",""		 	,"","","",""		  		  ,"","","","","","","","","","","",aHelp[1 ,1],aHelp[1 ,2],aHelp[1 ,3],"")
PutSx1(cPerg,"02","Dt Pagamento  ?" ,"","","mv_ch2","D",08,00,00,"G","",""     ,"","","MV_PAR02",""		 	,"","","",""		  		  ,"","","","","","","","","","","",aHelp[2 ,1],aHelp[2 ,2],aHelp[2 ,3],"")
PutSx1(cPerg,"03","Matricula de  ?" ,"","","mv_ch3","C",06,00,00,"G","","SRA"  ,"","","MV_PAR03",""		 	,"","","",""		  		  ,"","","","","","","","","","","",aHelp[3 ,1],aHelp[3 ,2],aHelp[3 ,3],"")
PutSx1(cPerg,"04","Matricula ate ?" ,"","","mv_ch4","C",06,00,00,"G","","SRA"  ,"","","MV_PAR04",""		 	,"","","",""		  		  ,"","","","","","","","","","","",aHelp[4 ,1],aHelp[4 ,2],aHelp[4 ,3],"")

//PutSx1(cPerg,"09","Tipo	         ?" ,"","","mv_ch9","N",01,00,00,"C","",""     ,"","","MV_PAR09","Preparação","","","","Inserto Metálico" ,"","","","","","","","","","","",aHelp[9 ,1],aHelp[9 ,2],aHelp[9 ,3],"")

Return (Nil)
