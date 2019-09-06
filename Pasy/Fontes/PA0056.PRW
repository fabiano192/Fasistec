#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Pa0056    º Autor ³ Alexandro da Silva º Data ³  21/03/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍaÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Geração do arquivo do Produto Acabado com o Ult.Preço de   º±±
±±º          ³ Venda com as Respectivas Materias Primas.                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SigaFat                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function Pa0056()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private _cPerg    := "PA0044"
Private _oGeraTxt

Private _cString  := "Sb1"


Pergunte(_cPerg,.F.)

dbSelectArea("Sb1")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da tela de processamento.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
         
_nOpc := 0
@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Geracao de Arquivo do P.A")
@ 02,10 TO 080,220
@ 10,018 Say " Este programa ira gerar um arquivo pacommp.dbf , conforme os   " SIZE 160,7
@ 18,018 Say " parametros definidos  pelo usuario,  com os registros da tabela" SIZE 160,7
@ 26,018 Say " de Produtos.                                                   " SIZE 160,7
//@ 85,128 BMPBUTTON TYPE 01 ACTION Proc1()
//@ 85,158 BMPBUTTON TYPE 02 ACTION Close(_oGeraTxt)
//@ 85,188 BMPBUTTON TYPE 05 ACTION Pergunte(_cPerg,.T.)
                                         
@ 85,128 BMPBUTTON TYPE 5 ACTION Pergunte(_cPerg,.T.)
@ 85,158 BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())
@ 85,188 BMPBUTTON TYPE 2 ACTION oDlg:END()

ACTIVATE DIALOG oDlg Centered
                             
If _nOpc == 1
	Proc1()
Endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ OKGERATXTº Autor ³ AP5 IDE            º Data ³  07/06/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao chamada pelo botao OK na tela inicial de processamenº±±
±±º          ³ to. Executa a geracao do arquivo texto.                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Proc1()


Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| Proc2(@_lFim) }
Private _cTitulo01 := 'Processando'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

Return


Static Function Proc2(_lFim)

//////////////////////////////////
/////// PA0044 ///////////////////
//// MV_PAR01  : Produto De  /////
//// MV_PAR02  : Produto Ate /////
//// MV_PAR03  : Tipo De     /////
//// MV_PAR04  : Tipo Ate    /////
////                         /////
//////////////////////////////////

aStru := {}
AADD(aStru,{"PRODPASY", "C" ,15, 0 })
AADD(aStru,{"PRODMP"  , "C" ,15, 0 })
AADD(aStru,{"PRODCLI" , "C" ,15, 0 })
AADD(aStru,{"DESCPRO" , "C" ,30, 0 })
AADD(aStru,{"CODCLI"  , "C" ,06, 0 })
AADD(aStru,{"LOJA"    , "C" ,02, 0 })
AADD(aStru,{"NOMCLI"  , "C" ,30, 0 })
AADD(aStru,{"CUSTOMP" , "N" ,14, 6 })
AADD(aStru,{"VALOR"   , "N" ,14, 4 })

cArqTRB := CriaTrab(aStru,.T.)
cIndTRB := "PRODPASY+PRODMP"//CLI+CODCLI+LOJA"
dbUseArea(.T.,,cArqTRB,"TRB",.F.,.F.)
dbSelectArea("TRB")
IndRegua("TRB",cArqTRB,cIndTRB,,,"Criando Trabalho...")

dbSelectArea("SZ2")
dbSetOrder(2)
dbSeek(xFilial("SZ2")+MV_PAR01,.T.)

Private _nVlMP := 0
ProcRegua(LastRec())

While !Eof() .And. SZ2->Z2_PRODUTO <=MV_PAR02
	
	IncProc()
	
	If SZ2->Z2_CLIENTE != "000171"
		dbSelectArea("SZ2")
		dbSkip()
		Loop
	Endif                  
	
	If SZ2->Z2_ATIVO == "2"
		dbSelectArea("SZ2")
		dbSkip()
		Loop
	Endif                  

	_aAliSB12 := GetArea()
	dbSelectArea("SG1")
	dbSetOrder(1)
	If dbSeek(xFilial("SG1")+SZ2->Z2_PRODUTO)
		
		_cProd   := SG1->G1_COD
		nNivel   := 2
		
		VERESTR(_cProd,IF(SB1->B1_QB==0,1,SB1->B1_QB),nNivel,IF(SB1->B1_QB==0,1,SB1->B1_QB),SB1->B1_OPC,SB1->B1_REVATU)
	Endif
	
	RestArea(_aAliSB12)
	
	dbSelectArea("SZ2")
	dbSkip()
EndDo

_cArqNovo := "CUSTOMP.DBF"
dbSelectArea("TRB")
Copy all to &_cArqNovo

dbCloseArea()

FErase(cArqTrb+".DBF")

Return



Static Function VERESTR(_cProd,_nQtPai,nNivel,_nQtBase,_cOpc,_cRev)

Local _nReg,nQuantItem := 0
Local _nRegTrb := 0
dbSelectArea("SG1")
dbSetOrder(1)
While !Eof() .And. SG1->G1_FILIAL + SG1->G1_COD == xFilial("SG1") + _cProd
	
	_nReg := Recno()
	
	nQuantItem := ExplEstr(_nQtPai,,_cOpc,_cRev)
	dbSelectArea("SG1")
	dbSetOrder(1)
	
	dbSelectArea("SB1")
	_aAliSB1 := GetArea()
	dbSeek(xFilial("SB1")+SG1->G1_COMP)
	_cDescMP := SB1->B1_DESC
	
	If SB1->B1_TIPO == "MP"
		
		_dDataRef := SZ2->Z2_DTREF01
		_nValor   := SZ2->Z2_PRECO01
		For i := 2 to 12
			If &("SZ2->Z2_DTREF"+StrZero(i,2)) >= _dDataRef
				_dDataRef := &("SZ2->Z2_DTREF"+StrZero(i,2))
				_nValor   := &("SZ2->Z2_PRECO"+StrZero(i,2))
			Endif
		Next i
		
		dbSelectArea("TRB")
		RecLock("TRB",.T.)
		TRB->PRODPASY := SZ2->Z2_PRODUTO
		TRB->PRODCLI  := SZ2->Z2_CODCLI
		TRB->CODCLI   := SZ2->Z2_CLIENTE
		TRB->LOJA     := SZ2->Z2_LOJA
		TRB->PRODMP   := SG1->G1_COMP
		TRB->DESCPRO  := SB1->B1_DESC
		TRB->CUSTOMP  := (SB1->B1_UPRC * nQuantItem)
		TRB->VALOR    := _nValor
		MsUnLock()
		
	Endif
	
	RestArea(_aAliSB1)
	
	dbSelectArea("SG1")
	dbSetOrder(1)
	dbSeek(xFilial("SG1")+SG1->G1_COMP)
	IF Found()
		dbSelectArea("SB1")
		dbSeek(xFilial("SB1")+SG1->G1_COD)
		VERESTR(SG1->G1_COD,nQuantItem,nNivel,IF(SB1->B1_QB==0,1,SB1->B1_QB),SB1->B1_OPC,SB1->B1_REVATU)
	EndIf
	
	dbSelectArea("SG1")
	dbGoto(_nReg)
	
	dbSkip()
EndDo

Return          
