#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PA0107    º Autor ³ Fabiano da Silva  º Data ³  23/10/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Baixa por natureza (AB-)                                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PA0107()

cDesc1         := "Este programa tem como objetivo imprimir relatorio "
cDesc2         := "de acordo com os parametros informados pelo usuario."
cDesc3         := "Baixa por natureza"
cPict          := ""
Cabec1         := ""
Cabec2         := ""
imprime        := .T.
//aOrd	       := {}                                            
//aOrd	       := {OemToAnsi("Natureza+Prefixo+Numero"),OemToAnsi("Dt Emissao+Prefixo+Numero"),OemToAnsi("VencimentoPrefixo+Numero"),OemToAnsi("Numero")}
aOrd	       := {OemToAnsi("Natureza"),OemToAnsi("Dt Emissao"),OemToAnsi("Vencimento"),OemToAnsi("Numero")}
lEnd           := .F.
lAbortPrint    := .F.
CbTxt          := ""
limite         := 132
tamanho        := "M"
nomeprog       := "PA0107"
nTipo          := 18
aReturn        := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
nLastKey       := 0
cbtxt          := Space(10)
cbcont         := 00
CONTFL         := 01
m_pag          := 01
wnrel          := "PA0107"
cPerg          := "PA0107"
nOrdem         :=0
cString        := "SE5"
titulo         := ""

dbSelectArea("SE5")
dbSetOrder(1)

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
                                                   
Pergunte("PA0107",.F.)

  /*
  PERGUNTAS PA0107
MV_PAR01  :=  NATUREZA DE
MV_PAR02  :=  NATUREZA ATE
MV_PAR03  :=  DT BAIXA DE 
MV_PAR04  :=  DT BAIXA ATE
MV_PAR05  :=  TITULO DE
MV_PAR06  :=  TITULO ATE
MV_PAR07  :=  CLIENTE DE
MV_PAR08  :=  CLIENTE ATE
MV_PAR09  :=  LOJA DE
MV_PAR10  :=  LOJA ATE
MV_PAR11  :=  EMISSAO DE
MV_PAR12  :=  EMISSAO ATE
MV_PAR13  :=  VENCTO DE
MV_PAR14  :=  VENCTO ATE
    */                  
/*         
0          12      20      28
NATUREZA   PREFIXO NUMERO  PAR  CLIENTE LOJA  NOME                                       EMISSAO  VENCTO   DT BAIXA  VALOR
9999999999 999     999999  999  999999  99    99999999999999999999999999999999999999999  99999999 99999999 99999999  999999999999999 
0          12      20      28   33      41    47                                         90       99       108       118
*/    
    
Cabec1       := "NATUREZA   PREFIXO NUMERO  PAR  CLIENTE LOJA  NOME                                       EMISSAO  VENCTO   DT BAIXA            VALOR"
Cabec2       := ""                                                                                           
titulo       := "Baixa por natureza (AB-)- Emissao: "+dToc(MV_PAR11)+" ate "+dToc(MV_PAR12)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

RptStatus({|| PA107_A(Cabec1,Cabec2,Titulo) },Titulo)

Return


Static Function PA107_A(Cabec1,Cabec2,Titulo)

nOrdem := aReturn[8]
           
aCampos := {}
AADD(aCampos,{ "NATUREZ"   ,"C", 10, 0 } )
AADD(aCampos,{ "PREFIXO"   ,"C", 03, 0 } )
AADD(aCampos,{ "NUMERO"    ,"C", 06, 0 } )
AADD(aCampos,{ "PARCELA"   ,"C", 01, 0 } )
AADD(aCampos,{ "CLIENTE"   ,"C", 06, 0 } )
AADD(aCampos,{ "LOJA"      ,"C", 02, 0 } )
AADD(aCampos,{ "NOMECLI"   ,"C", 40, 0 } )
AADD(aCampos,{ "EMISSAO"   ,"D", 08, 0 } )
AADD(aCampos,{ "VENCREA"   ,"D", 08, 0 } )
AADD(aCampos,{ "DTDIGIT"   ,"D", 08, 0 } )
AADD(aCampos,{ "VALOR"     ,"N", 17, 2 } )

cArqLOG := CriaTrab(aCampos,.T.)
cIndLOG := "NATUREZ+PREFIXO+NUMERO"
dbUseArea(.T.,,cArqLOG,"TMP",.F.,.F.)

dbSelectArea("SE5")
dbOrderNickName("INDSE51")    
dbSeek(xFilial("SE5")+dTos(MV_PAR03),.T.)

ProcRegua(LastRec())
               
_nTotal := 0                       
_nTit   := 0
While !EOF() .And. SE5->E5_DTDISPO <= MV_PAR04

	IncProc("Selecionando Registros")
	
   	If lAbortPrint
	 	@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
	   	Exit
	Endif
                                                                                                                                                                    	
	dbSelectArea("SE1")
	dbsetOrder(2)
	If dbSeek(xFilial("SE1")+SE5->E5_CLIFOR+SE5->E5_LOJA+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+"AB-")
	                                                                                                         
       	If SE5->E5_TIPO != "NF " .OR.;
			SE5->E5_MOTBX = "CMP" .OR.;
			SE5->E5_RECPAG != "R"
			dbSelectArea("SE5")
			dbSkip()
			Loop
		Endif

       	If SE1->E1_NATUREZ < MV_PAR01 .OR. SE1->E1_NATUREZ > MV_PAR02 .OR.;				
	   		SE1->E1_NUM < MV_PAR05 .OR. SE1->E1_NUM > MV_PAR06 .OR.;
			SE1->E1_CLIENTE < MV_PAR07 .OR. SE1->E1_CLIENTE > MV_PAR08 .OR.;
			SE1->E1_LOJA < MV_PAR09 .OR. SE1->E1_LOJA > MV_PAR10 .OR.;
			SE1->E1_EMISSAO < MV_PAR11 .OR. SE1->E1_EMISSAO > MV_PAR12 .OR.;
			SE1->E1_VENCREA < MV_PAR13 .OR. SE1->E1_VENCREA > MV_PAR14		
	  		dbSelectArea("SE5")
	 		dbSkip()
	  		Loop
	 	Endif
		
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek(xFilial("SA1")+SE5->E5_CLIFOR+SE5->E5_LOJA)

		dbSelectArea("TMP")
		RecLock("TMP",.T.)
		TMP->NATUREZ  := SE1->E1_NATUREZ
		TMP->PREFIXO  := SE1->E1_PREFIXO 
		TMP->NUMERO   := SE1->E1_NUM  
		TMP->PARCELA  := SE1->E1_PARCELA 
		TMP->CLIENTE  := SE1->E1_CLIENTE  
		TMP->LOJA     := SE1->E1_LOJA    
		TMP->NOMECLI  := Substr(SA1->A1_NOME,1,40)
		TMP->EMISSAO  := SE1->E1_EMISSAO   
		TMP->VENCREA  := SE1->E1_VENCREA 
		TMP->DTDIGIT  := SE5->E5_DTDIGIT 
		TMP->VALOR    := SE1->E1_VALOR
		MsUnlock()
		
	Endif

    dbSelectArea("SE5")
	dbSkip()
EndDo   

Imprime()           

_cArqNew := "\TEMP.DBF"
dbSelectArea("TMP")    
Copy To &_cArqNew

dbCloseArea()
    
SET DEVICE TO SCREEN

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return
         
         
Static Function Imprime()

nLin      := 80                

dbSelectArea("TMP")      
                                                  
IF nOrdem == 1
	_cArq2   := CriaTrab(NIL,.F.)
	_cChave2 := "NATUREZ"
	IndRegua("TMP",_cArq2,_cChave2,,,"Indexando TMP...")
Elseif nOrdem == 2
	_cArq2   := CriaTrab(NIL,.F.)
	_cChave2 := "EMISSAO"
	IndRegua("TMP",_cArq2,_cChave2,,,"Indexando TMP...")
Elseif nOrdem == 3
	_cArq2   := CriaTrab(NIL,.F.)
	_cChave2 := "VENCREA"
	IndRegua("TMP",_cArq2,_cChave2,,,"Indexando TMP...")
Elseif nOrdem == 4
	_cArq2   := CriaTrab(NIL,.F.)
	_cChave2 := "NUMERO"
	IndRegua("TMP",_cArq2,_cChave2,,,"Indexando TMP...")
Endif   

dbGotop()
                    
While !EOF()
	
   	If lAbortPrint
	 	@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
	   	Exit
	Endif

	If nLin > 55 
 	   	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
 	   	nLin := 8
 	Endif
	
	@nLin,00  PSAY TMP->NATUREZ
	@nLin,12  PSAY TMP->PREFIXO
	@nLin,20  PSAY TMP->NUMERO
	@nLin,28  PSAY TMP->PARCELA
	@nLin,33  PSAY TMP->CLIENTE
	@nLin,41  PSAY TMP->LOJA
	@nLin,47  PSAY TMP->NOMECLI
	@nLin,90  PSAY TMP->EMISSAO
	@nLin,99  PSAY TMP->VENCREA
	@nLin,108 PSAY TMP->DTDIGIT
	@nLin,118 PSAY TMP->VALOR    Picture TM(TMP->VALOR,14,2)
	
	_nTotal += TMP->VALOR   
	_nTit   += 1
  		
	nLin := nLin + 1

	dbSelectarea("TMP")
	dbSkip()
EndDo	    
                                                       
nLin := nLin + 1      

@nLin,000 PSAY "TOTAL ------>"
@nLin,020 PSAY _nTit
@nLin,025 PSAY " TITULO(S)"
@nLin,118 PSAY _nTotal   Picture TM(_nTotal,14,2)
	
Return