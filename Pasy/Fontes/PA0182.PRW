#Include "Protheus.ch"
#Include "TOPCONN.ch"

/*
Programa 	: PA0182
Descrição	: Gerar arquivo Word conforme modelo referente ao Termo de Aquisição e Quitação dos valores da demissão
Data		: 27/05/09
Autor		: Fabiano da Silva
Uso			: SIGAGPE - Gestão de Pessoal
*/

User Function PA0182()

LOCAL oDlg 		:= NIL
PRIVATE cTitulo := "GERACAO DE ARQUIVO WORD - TERMO"

AtuSX1()

DEFINE MSDIALOG oDlg FROM 264,182 TO 441,613 TITLE cTitulo OF oDlg PIXEL
@ 004,010 TO 082,157 LABEL "" OF oDlg PIXEL

@ 010,017 SAY "Esta rotina tem por objetivo gerar o arquivo    " OF oDlg PIXEL Size 150,010
@ 020,017 SAY "Word referente ao Termo de Transação e Quitação " OF oDlg PIXEL Size 150,010
@ 030,017 SAY "da demissão do funcionário conform os parâmetros" OF oDlg PIXEL Size 150,010
@ 040,017 SAY "informados pelo usuário.                        " OF oDlg PIXEL Size 150,010
@ 060,017 SAY "                                                " OF oDlg PIXEL Size 150,010
@ 070,017 SAY "Programa PA0182.PRW                             " OF oDlg PIXEL Size 150,010

@ 10,167 BUTTON "Parametros" SIZE 036,012 ACTION ( Pergunte("PA0182"))	OF oDlg PIXEL
@ 35,167 BUTTON "OK" 		 SIZE 036,012 ACTION (PA182A(),oDlg:End()) 	OF oDlg PIXEL
@ 60,167 BUTTON "Sair"       SIZE 036,012 ACTION ( oDlg:End()) 			OF oDlg PIXEL

ACTIVATE MSDIALOG oDlg CENTERED                

Return(Nil)


Static Function PA182A()

Local hWord
Local cPed
Local cNome

Pergunte("PA0182",.F.)

/* VARIÁVEIS P/ O DOCUMENTO WORD
cNome
cFuncao
dAdmissao
dDemissao
cVerba01,cVerba02,cVerba03,cVerba04,cVerba05,cVerba06,cVerba07,cVerba08,cVerba09,cVerba10
cVerba11,cVerba12,cVerba13,cVerba14,cVerba15,cVerba16,cVerba17,cVerba18,cVerba19,cVerba20
nValor01,nValor02,nValor03,nValor04,nValor05,nValor06,nValor07,nValor08,nValor09,nValor10
nValor11,nValor12,nValor13,nValor14,nValor15,nValor16,nValor17,nValor18,nValor19,nValor20
nLiquido
*/

cQuery	:= " SELECT RR_MAT,RR_PD,RR_VALOR,RR_DATA,RA_DEMISSA,RA_NOME,RV_DESC,RV_TIPOCOD,RJ_DESC FROM "+RetSqlName("SRR")+" SRR (NOLOCK) "
cQuery	+= " INNER JOIN "+RetSqlName("SRA")+" SRA (NOLOCK) ON RA_MAT = RR_MAT "
cQuery	+= " INNER JOIN "+RetSqlName("SRV")+" SRV (NOLOCK) ON RV_COD = RR_PD "
cQuery	+= " INNER JOIN "+RetSqlName("SRJ")+" SRJ (NOLOCK) ON RA_CODFUNC = RJ_FUNCAO "
cQuery	+= " WHERE SRR.D_E_L_E_T_ = '' AND SRA.D_E_L_E_T_ = '' AND SRV.D_E_L_E_T_ = '' AND SRJ.D_E_L_E_T_ = '' "
cQuery	+= " AND RR_MAT = "+MV_PAR01+" AND RR_DATA = "+DTOS(MV_PAR02)+" AND RR_TIPO3 = 'R' AND RV_TIPOCOD IN ('1','2') "
cQuery	+= " ORDER BY RV_TIPOCOD,RR_PD "

TCQUERY cQuery New ALIAS "ZRR"

TCSETFIELD("ZRR","RR_DATA"		,"D")
TCSETFIELD("ZRR","RA_DEMISSA"	,"D")

ZRR->(dbGoTop())

hWord := OLE_CreateLink()
OLE_NewFile(hWord,"C:\TERMO.DOT")

_cNome := ZRR->RA_NOME
OLE_SetDocumentVar(hWord,'cNome',ZRR->RA_NOME)
OLE_SetDocumentVar(hWord,'cFuncao',ZRR->RJ_DESC)
OLE_SetDocumentVar(hWord,'dDemissao',ZRR->RR_DATA)
OLE_SetDocumentVar(hWord,'dAdmissao',ZRR->RA_DEMISSA)

_nConT := 1
While ZRR->(!EOF()) .And. _nCont < 21

	If ZRR->RR_PD = '428'  // Líquido pago na Recisão
//		OLE_SetDocumentVar(hWord,'cVerba'+STRZERO(_nCont,2),ZRR->RV_DESC)
		OLE_SetDocumentVar(hWord,'nLiquido',Trans(ZRR->RR_VALOR	, "@E 99,999.99"))
	Else	
		OLE_SetDocumentVar(hWord,'cVerba'+STRZERO(_nCont,2),ZRR->RV_DESC)
		OLE_SetDocumentVar(hWord,'nValor'+STRZERO(_nCont,2),Trans(ZRR->RR_VALOR	, "@E 99,999.99"))
		_nCont ++
	Endif	
	
	ZRR->(dbSkip())
EndDo	

If _nCont < 21
	For F := _nCont To 20
		OLE_SetDocumentVar(hWord,'cVerba'+STRZERO(F,2)," ")
		OLE_SetDocumentVar(hWord,'nValor'+STRZERO(F,2)," ")
	Next F
Endif	


OLE_UpdateFields(hWord)

OLE_SaveAsFile(hWord,"C:\TERMO - "+_cNome+".DOC")

OLE_CloseLink(hWord)

ShellExecute('Open',"C:\TERMO - "+_cNome+".DOC","","",1)

Return (Nil)


Static Function AtuSx1(cPerg)

Local aHelp := {}
cPerg       := "PA0182"

//            Texto do help em português        			 	, Inglês, Espanhol
AAdd(aHelp, {{"Informe a Matricula do Funcionário"				}, {""} , {""}})
AAdd(aHelp, {{"Informa data de Demissão"						}, {""} , {""}})

PutSx1(cPerg,"01","Matricula    ?" ,"","","mv_ch1","C",06,00,00,"G","","SRA"     ,"","","MV_PAR01",""		 	,"","","",""		  		  ,"","","","","","","","","","","",aHelp[1 ,1],aHelp[1 ,2],aHelp[1 ,3],"")
PutSx1(cPerg,"02","Dt Demissao  ?" ,"","","mv_ch2","D",08,00,00,"G","",""  ,"","","MV_PAR02",""		 	,"","","",""		  		  ,"","","","","","","","","","","",aHelp[2 ,1],aHelp[2 ,2],aHelp[2 ,3],"")
//PutSx1(cPerg,"09","Tipo	         ?" ,"","","mv_ch9","N",01,00,00,"C","",""     ,"","","MV_PAR09","Preparação","","","","Inserto Metálico" ,"","","","","","","","","","","",aHelp[9 ,1],aHelp[9 ,2],aHelp[9 ,3],"")

Return (Nil)
