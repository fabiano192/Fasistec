#INCLUDE "Protheus.ch"
#INCLUDE "TOPCONN.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PA0171    º Autor ³ Fabiano da Silva   º Data ³  10/02/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatório de NF vinculadas ao Embarque                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Faturamento (SIGAFAT)                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PA0171()

Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := ""
Local cPict         := ""
Local titulo       	:= "Relatório de NF vinculada ao Embarque"
Local nLin         	:= 80
/*
NF     PROCESSO   PEDIDO  PROD_PAS        PROD_CLI         REF_CLI    CLIENTE/LJ
AAAAAA AAAAAAAAAA AAAAAA  AAAAAAAAAAAAAAA AAAAAAAAAAAAAAA  AAAAAAAAAA  AAAAAA/AA
0      7          18      26              42               59          71
*/   
Local Cabec1       	:= "NF     PROCESSO   PEDIDO  PROD_PAS        PROD_CLI         REF_CLI    CLIENTE/LJ"
Local Cabec2       	:= ""
Local imprime      	:= .T.
Local aOrd 			:= {}
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 80
Private tamanho     := "P"
Private nomeprog    := "PA0171"
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private cPerg       := "PA0171"
Private cbtxt      	:= Space(10)
Private cbcont     	:= 00
Private CONTFL     	:= 01
Private m_pag      	:= 01
Private wnrel      	:= "PA0171"
Private cString 	:= "EE9"

ATUSX1(cPerg)

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

RptStatus({|| PA171A(Cabec1,Cabec2,Titulo,nLin,cPerg) },Titulo)

Return (Nil)


Static Function PA171A(Cabec1,Cabec2,Titulo,nLin,cPerg)

pergunte(cPerg,.F.)

_cQuery := " SELECT EE9_COD_I,EE9_PART_N,EE9_NF,EE9_PEDIDO,EE9_PREEMB,EEC_IMPORT,EEC_IMLOJA,EE9_REFCLI FROM "+RetSqlName("EE9")+" A (NOLOCK) "
_cQuery += " INNER JOIN "+RetSqlName("EEC")+" B (NOLOCK) ON EEC_PREEMB = EE9_PREEMB "
_cQuery += " WHERE A.D_E_L_E_T_ = '' AND B.D_E_L_E_T_ = '' "
_cQuery += " AND EE9_NF BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
_cQuery += " AND EE9_COD_I BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
_cQuery += " AND EE9_PREEMB BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
_cQuery += " ORDER BY EE9_NF,EE9_PREEMB "

TCQUERY _cQuery New Alias "ZZ"

dbSelectArea("ZZ")

SetRegua(RecCount())

ZZ->(dbGoTop())
While ZZ->(!EOF())

   	If lAbortPrint
      	@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      	Exit
   	Endif

   	If nLin > 55
      	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      	nLin := 8
   	Endif
/*
NF     PROCESSO   PEDIDO  PROD_PAS        PROD_CLI         REF_CLI    CLIENTE/LJ
0      7          18      26              42               59          71
*/   
	@nLin,00 PSAY Substr(ZZ->EE9_NF,1,6)
	@nLin,07 PSAY Substr(ZZ->EE9_PREEMB,1,10)
	@nLin,18 PSAY ZZ->EE9_PEDIDO
	@nLin,26 PSAY ZZ->EE9_COD_I
	@nLin,42 PSAY Substr(ZZ->EE9_PART_N,1,15)
	@nLin,59 PSAY Substr(ZZ->EE9_REFCLI,1,10)
	@nLin,71 PSAY ZZ->EEC_IMPORT+"/"+ZZ->EEC_IMLOJA

   	nLin ++

   	ZZ->(dbSkip())
EndDo

ZZ->(dbCloseArea())

SET DEVICE TO SCREEN

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return (Nil)


Static Function AtuSx1(cPerg)

Local aHelp := {}

//            Texto do help em português        	, inglês, espanhol
AAdd(aHelp, {{"Informe a NF Inicial"				}, {""} , {""}})
AAdd(aHelp, {{"Informe a NF Final"  				}, {""} , {""}})
AAdd(aHelp, {{"Informe o Produto Inicial"   		}, {""} , {""}})
AAdd(aHelp, {{"Informe o Produto Final"     		}, {""} , {""}})
AAdd(aHelp, {{"Informe o Processo Inicial"       	}, {""} , {""}})
AAdd(aHelp, {{"Informe o Processo Final"         	}, {""} , {""}})

PutSx1(cPerg,"01","NF de           ?" ,"","","mv_ch1","C",06,00,00,"G","","SF2","","","MV_PAR01","","","","","","","","","","","","","","","","",aHelp[1,1],aHelp[1,2],aHelp[1,3],"")
PutSx1(cPerg,"02","NF ate          ?" ,"","","mv_ch2","C",06,00,00,"G","","SF2","","","MV_PAR02","","","","","","","","","","","","","","","","",aHelp[2,1],aHelp[2,2],aHelp[2,3],"")
PutSx1(cPerg,"03","Produto de      ?" ,"","","mv_ch3","C",15,00,00,"G","","SB1","","","MV_PAR03","","","","","","","","","","","","","","","","",aHelp[3,1],aHelp[3,2],aHelp[3,3],"")
PutSx1(cPerg,"04","Produto ate     ?" ,"","","mv_ch4","C",15,00,00,"G","","SB1","","","MV_PAR04","","","","","","","","","","","","","","","","",aHelp[4,1],aHelp[4,2],aHelp[4,3],"")
PutSx1(cPerg,"05","Processo de     ?" ,"","","mv_ch5","C",20,00,00,"G","","EEC","","","MV_PAR05","","","","","","","","","","","","","","","","",aHelp[5,1],aHelp[5,2],aHelp[5,3],"")
PutSx1(cPerg,"06","Processo ate    ?" ,"","","mv_ch6","C",20,00,00,"G","","EEC","","","MV_PAR06","","","","","","","","","","","","","","","","",aHelp[6,1],aHelp[6,2],aHelp[6,3],"")

//PutSx1(cPerg,"07","Gera Duplicata  ?" ,"","","mv_ch7","C",01,00,00,"C","",""   ,"","","MV_PAR05","Sim","","","","Não","","","Ambos","","","","","","","","",aHelp[7,1],aHelp[7,2],aHelp[7,3],"")

Return (Nil)
