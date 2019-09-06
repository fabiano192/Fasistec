#include "rwmake.ch"       

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ PA0102  ³ Autor ³ Alexandro da Silva     ³ Data ³ 11/09/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Emite uma relacao informando onde um determinado componen- ³±±
±±³          ³ te e utilizado.                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Estoque / Custos                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
/*/

User Function PA0102()

LOCAL wnrel  	 := "PA0102"
LOCAL Tamanho	 := "P"
LOCAL titulo 	 := "Onde e Usado"
LOCAL cDesc1 	 := "Emite uma relatorio informando onde determinados materiais selecionados"
LOCAL cDesc2 	 := "sao utilizados na composicao da estrutura."
LOCAL cDesc3 	 := ""
LOCAL cString    := "SB1"
PRIVATE aReturn  := { OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 2, 2, 1, "",1 }
PRIVATE nLastKey := 0 ,cPerg := "PA0102"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01             // Componente de                        ³
//³ mv_par02             // Componente ate                       ³
//³ mv_par03             // Impr. Comp. Vencido                  ³
//³ mv_par04             // Visual. Todos Niveis                 ³
//³ mv_par05             // Grupo de                             ³
//³ mv_par06             // Grupo Ate                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

pergunte(cPerg,.F.)

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho)

If nLastKey = 27
	Set Filter to
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey = 27
	Set Filter to
	Return
Endif

RptStatus({|lEnd| PA0102A(@lEnd,wnRel,titulo,Tamanho)},titulo)

Return NIL


Static Function PA0102A(lEnd,WnRel,titulo,Tamanho)

LOCAL cbCont := 0
LOCAL cbTxt  := Space(10)
LOCAL limite := 80
LOCAL nTipo  := 0
LOCAL nCol   := IIF(mv_par04==1,-2,0)

LOCAL nRecComp ,cCodComp ,cDescComp ,cTipoComp ,cGrupoComp ,cUMComp ,lImprime

li       := 80
m_pag    := 1
imprime  := .T.
nOrdem   := aReturn[8]
nTipo    := IIF(aReturn[4]=1,15,18)

Cabec1 := "COMPONENTE      DESCRICAO                      TP GRUPO UM       QUANTIDADE"
Cabec2 := "PRODUTO                                                           UTILIZADA"

/*                                                                                        
COMPONENTE      DESCRICAO                      TP GRUPO UM       QUANTIDADE
PRODUTO                                                           UTILIZADA
999999999999999 999999999999999999999999999999 99 99999 99     999999999999
0               16                             47 50    56     63
*/

dbSelectArea("SB1")
SetRegua(RecCount())

dbSeek(xFilial("SB1")+mv_par01,.T.)

While !EOF() .And. B1_FILIAL+B1_COD <= xFilial("SB1")+mv_par02

	If lEnd
		@PROW()+1,001 PSay "Cancelado pelo Operador"
		Exit
	EndIf

	IncRegua()

	nRecComp   := RecNo()                
	cCodComp   := B1_COD
	cDescComp  := SubStr(B1_DESC,1,30)
	cTipoComp  := B1_TIPO
	cGrupoComp := B1_GRUPO
	cUMComp    := B1_UM
            
    If SB1->B1_GRUPO < MV_PAR05 .Or. SB1->B1_GRUPO > MV_PAR06
    	dbSelectArea("SB1")
    	dbSkip()
    	Loop
    Endif
		
	dbSelectArea("SG1")
	dbsetOrder(2)
	dbSeek(xFilial("SG1")+cCodComp)
	lImprime := .T.

	While !Eof() .And. SG1->G1_COMP == cCodComp

		If li > 60
			Cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
			lImprime := .T.
		EndIf

		dbSelectArea("SB1")
		dbSeek(xFilial("SB1")+SG1->G1_COD)
      
      	dbSelectArea("SG1")
		If ((dDataBase >= SG1->G1_INI .And. dDataBase <= SG1->G1_FIM) .Or. mv_par03 == 1)

			If lImprime
				@ li,000 PSay cCodComp+"    "+cDescComp+" "+cTipoComp+"  "+cGrupoComp+" "+cUMComp
				Li++
				Li++
				lImprime := .F.
			EndIf

			dbSelectArea("SB1")
			dbSeek(xFilial("SB1")+SG1->G1_COD)
			@ Li,000 PSay SB1->B1_COD
			@ Li,016 PSay SubStr(SB1->B1_DESC,1,30)
			@ Li,047 PSay SB1->B1_TIPO
			@ Li,050 PSay SB1->B1_GRUPO
			@ Li,056 PSay SB1->B1_UM
			dbSelectArea("SG1")
			@ Li,063 PSay SG1->G1_QUANT Picture PesqPictQt("G1_QUANT",12)
			Li++
		
   		   If mv_par04 == 1
		      PA0102B(SG1->G1_COD,titulo,cabec1,cabec2,wnrel,tamanho,nTipo)
		   Endif
		   
		EndIf
		   
		Skip

	EndDo

	If !lImprime
		@ Li,000 PSay __PrtThinLine()
		Li++
	EndIf

	dbSelectArea("SB1")
	Go nRecComp
	DbSkip()

EndDo

dbSelectArea("SB1")
Set Filter To
dbSetOrder(1)
dbSelectArea("SG1")
dbSetOrder(1)

If Li != 80
	Roda(cbcont,cbtxt,Tamanho)
EndIf

If aReturn[5] = 1
	Set Printer To 
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return NIL


STATIC Function PA0102B(cProduto,titulo,cabec1,cabec2,wnrel,tamanho,nTipo,nOpc) //Explode os niveis da Estrutura de Baixo para Cima       

LOCAL nReg := 0
LOCAL aAreaSG1 := SG1->(GetArea())	
LOCAL aAreaSB1 := SB1->(GetArea())	
Local cProd    := ""
nOpc2    := 1 //nOpc

dbSelectArea("SG1")
dbSetOrder(2)
dbSeek(xFilial("SG1")+cProduto)

While !Eof() .And. SG1->G1_COMP == cProduto
	nReg := Recno()
 
	If (dDataBase >= SG1->G1_INI .And. dDataBase <= SG1->G1_FIM) .Or. mv_par03 == 1
       
       dbSelectArea("SB1")
       dbSeek(xFilial("SB1")+SG1->G1_COD)
    
       If nOpc2 == 1
          If li > 60
	         Cabec(titulo,Cabec1,Cabec2,Wnrel,Tamanho,nTipo)
	      EndIf

		  @ Li,000 PSay SB1->B1_COD
		  @ Li,016 PSay SubStr(SB1->B1_DESC,1,30)
		  @ Li,047 PSay SB1->B1_TIPO
		  @ Li,050 PSay SB1->B1_GRUPO
		  @ Li,056 PSay SB1->B1_UM

          dbSelectArea("SG1")
	      @ Li,063 PSay SG1->G1_QUANT Picture PesqPictQt("G1_QUANT",12)
 	      Li++     
 	   ElseIf nOpc2 == 2
 	      cProd := SB1->B1_COD
 	   Endif
 	      
	Endif

	dbSelectArea("SG1")
	dbSetOrder(2)
	dbSeek(xFilial("SG1")+SG1->G1_COMP+SG1->G1_COD)
	IF Found()
		PA0102B(SG1->G1_COD,titulo,cabec1,cabec2,wnrel,Tamanho,nTipo,nOpc2)
	EndIf
	dbGoto(nReg)
	dbSkip()
EndDo

RestArea(aAreaSB1)
RestArea(aAreaSG1)

Return IIF(nOpc2==2,cProd,"")