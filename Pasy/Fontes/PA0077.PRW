#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Rotina   ³ PA0077   ³ Autor ³ Alexandro da Silva    ³ Data ³ 16.01/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Exporta Livro Fiscal Entrada / Saida                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Alterado ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PA0077()
                                 
_nOpc := 0
@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Exportacao do Livro Fiscal")
@ 02,10 TO 080,220
@ 10,18 SAY "Rotina criada para exportacao dos dados do Livro "    SIZE 160,7
@ 18,18 SAY "Fiscal para Escrituraçao do Livro Fiscal         "    SIZE 160,7
@ 26,18 SAY "Arquivo Exportado em F:\PROTHEUS11\PROTHEUS_DATA\Fiscal\      "    SIZE 160,7
@ 34,18 SAY "com o nome PASY.??? . Programa PA0077.PRW     "    SIZE 160,7

@ 85,128 BMPBUTTON TYPE 5 ACTION Pergunte("PA0077")
//@ 85,158 BMPBUTTON TYPE 1 ACTION Proces()
//@ 85,188 BMPBUTTON TYPE 2 ACTION Close(oDlg)
@ 85,158 BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())
@ 85,188 BMPBUTTON TYPE 2 ACTION oDlg:END()

ACTIVATE DIALOG oDlg Centered  //Valid Close(odlg)
                                        
If _nOpc == 1
	Proces()
Endif
	
Return


Static Function Proces()

Pergunte("PA0077",.F.)

//////////////////////////////////////
//////// PA0077  /////////////////////
//// MV_PAR01 : Data De ?         ////
//// MV_PAR02 : Data De ?         ////
////                              ////
//////////////////////////////////////

Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| Proc1(@_lFim) }
Private _cTitulo01 := 'Processando'

Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )


Return


Static Function Proc1(_lFim)


_cNomArqE  := "\FISCAL\PASY.E"+STRZERO(MONTH(MV_PAR01),2)
_cNomArqS  := "\FISCAL\PASY.S"+STRZERO(MONTH(MV_PAR01),2)


VerEntr(_lFim)
VerSaid(_lFim)


Return


Static Function VerEntr(_lFim)

aStru := {}
AADD(aStru,{ "EMISSAO   ","C", 04,0})
AADD(aStru,{ "SERIE     ","C", 03,0})
AADD(aStru,{ "NUMERO    ","C", 06,0})
AADD(aStru,{ "ATENUMERO ","C", 06,0})
AADD(aStru,{ "CFO       ","C", 05,0})
AADD(aStru,{ "VALCONT   ","C", 12,0})
AADD(aStru,{ "BASEICMS1 ","C", 12,0})
AADD(aStru,{ "ALIQICMS1 ","C", 02,0})
AADD(aStru,{ "ICMS1     ","C", 12,0})
AADD(aStru,{ "ISENTOICM1","C", 12,0})
AADD(aStru,{ "DTENTRADA","C", 04,0})
AADD(aStru,{ "DIAINTEGRA","C", 02,0})
AADD(aStru,{ "VAGO01    ","C", 02,0})
AADD(aStru,{ "OUTRASICM1","C", 12,0})
AADD(aStru,{ "BASEIPI   ","C", 12,0})
AADD(aStru,{ "IPI       ","C", 12,0})
AADD(aStru,{ "ISENTOIPI ","C", 12,0})
AADD(aStru,{ "OUTRASIPI ","C", 12,0})
AADD(aStru,{ "TIPONF    ","C", 02,0})
AADD(aStru,{ "CODCONTAB ","C", 02,0})
AADD(aStru,{ "OBS       ","C", 14,0})
AADD(aStru,{ "UF        ","C", 02,0})
AADD(aStru,{ "CGC       ","C", 14,0})
AADD(aStru,{ "INSCR     ","C", 16,0})
AADD(aStru,{ "RAZAOSOC  ","C", 35,0})
AADD(aStru,{ "DESCONTO  ","C", 12,0})
AADD(aStru,{ "ESPECIE   ","C", 03,0})
AADD(aStru,{ "IPINAO    ","C", 12,0})
AADD(aStru,{ "VALORVISTA","C", 12,0})
AADD(aStru,{ "VAGO02    ","C", 08,0})
AADD(aStru,{ "ICMSFONTE ","C", 12,0})
AADD(aStru,{ "NUMMUNIC  ","C", 04,0})
AADD(aStru,{ "CTAFORN   ","C", 18,0})
AADD(aStru,{ "CONTRIB   ","C", 01,0})
AADD(aStru,{ "VALORPRAZO","C", 11,0})

//cArqTrab := CriaTrab(aStru, .T.)
//USE &cArqTrab ALIAS TRB NEW

cArqLOG := CriaTrab(aStru,.T.)
cIndLOG := "EMISSAO+SERIE+NUMERO"
dbUseArea(.T.,,cArqLOG,"TRB",.F.,.F.)

dbSelectArea("TRB")
IndRegua("TRB",cArqLog,cIndLog,,,"Criando Trabalho...")



dbselectarea("SF3")
dbSetOrder(1)
dbSeek(xFilial("SF3")+DTOS(MV_PAR01),.T.)

ProcRegua(Reccount())

While !eof() .And. !_lFim .And. SF3->F3_ENTRADA <= MV_PAR02
	
	IncProc("Processando:"+DTOC(SF3->F3_ENTRADA))
	
	If subs(SF3->F3_CFO,1,1) >="5"
		dbselectarea("SF3")
		dbskip()
		loop
	Endif
	
	If SF3->F3_tipo $ "DB"
		dbselectarea("SA1")
		dbSetOrder(1)
		dbseek(xfilial("SA1")+SF3->F3_CLIEFOR+SF3->F3_LOJA)
		cCGC    := SA1->A1_CGC
		cINSCR  := SA1->A1_INSCR
		cRAZAO  := SA1->A1_NOME
		cCONTA  := SA1->A1_CONTA
	Else
		dbselectarea("SA2")
		dbSetOrder(1)
		dbseek(xfilial("SA2")+SF3->F3_CLIEFOR+SF3->F3_LOJA)
		cCGC    := SA2->A2_CGC
		cINSCR  := SA2->A2_INSCR
		cRAZAO  := SA2->A2_NOME
		cCONTA  := SA2->A2_CONTA
	Endif
	
	dbselectarea("TRB")
	Reclock("TRB",.t.)
	//	TRB->TIPOREG   := "R1"
	TRB->EMISSAO   := subs(dtos(SF3->F3_EMISSAO),7,2)+subs(dtos(SF3->F3_EMISSAO),5,2)
	TRB->SERIE     := SF3->F3_serie
	TRB->NUMERO    := StrZero(Val(SF3->F3_NFISCAL),6)
	TRB->ATENUMERO := StrZero(Val(SF3->F3_NFISCAL),6)
	TRB->CFO       := SF3->F3_CFO
	TRB->VALCONT   := Strzero((SF3->F3_VALCONT*100),12)
	TRB->BASEICMS1 := Strzero((SF3->F3_BASEICM*100),12)
	TRB->ALIQICMS1 := Strzero((SF3->F3_ALIQICM*10000),6)
	TRB->ICMS1     := Strzero((SF3->F3_VALICM*100),12)
	TRB->ISENTOICM1:= Strzero((SF3->F3_ISENICM*100),12)
	TRB->DTENTRADA := subs(dtos(SF3->F3_ENTRADA),7,2)+subs(dtos(SF3->F3_ENTRADA),5,2)
	TRB->DIAINTEGRA:= Strzero(day(ddatabase),2)
	TRB->VAGO01    := Space(02)
	TRB->OUTRASICM1:= Strzero((SF3->F3_OUTRICM*100),12)
	TRB->BASEIPI   := Strzero((SF3->F3_BASEIPI*100),12)
	TRB->IPI       := Strzero((SF3->F3_VALIPI*100),12)
	TRB->ISENTOIPI := Strzero((SF3->F3_ISENIPI*100),12)
	TRB->OUTRASIPI := Strzero((SF3->F3_OUTRIPI*100),12)
	If !EMPTY(SF3->F3_DTCANC)
		TRB->TIPONF  := "99"
	ELSE
		TRB->TIPONF  := "00"
	ENDIF
	TRB->CODCONTAB := "00"
	TRB->OBS       := SF3->F3_OBSERV
	TRB->UF        := SF3->F3_ESTADO
	TRB->CGC       := cCGC
	TRB->INSCR     := cINSCR
	TRB->RAZAOSOC  := cRAZAO
	TRB->DESCONTO  := STRZERO(0,12)
	TRB->ESPECIE   := SF3->F3_ESPECIE
	TRB->IPINAO    := Strzero((SF3->F3_IPIOBS*100),12)
	TRB->VALORVISTA:= Strzero((SF3->F3_VALCONT*100),12)
	TRB->VAGO02    := Space(02)
	TRB->ICMSFONTE := Strzero((SF3->F3_ICMSRET*100),12)
	TRB->NUMMUNIC  := "0000"
	TRB->CTAFORN   := cCONTA
	IF EMPTY(cINSCR)
		TRB->CONTRIB   := "1"
	Else
		TRB->CONTRIB   := "0"
	ENDIF
	TRB->VALORPRAZO:= Strzero((SF3->F3_VALCONT*100),12)
	MsUnlock()
	
	dbselectarea("SF3")
	dbSkip()
EndDo

dbselectarea("TRB")
COPY TO &_cNomArqE SDF

dbclosearea("TRB")

dbselectarea("SF3")

Return



Static Function VerSaid(_lFim)


aStru := {}
AADD(aStru,{ "EMISSAO   ","C", 04,0})
AADD(aStru,{ "SERIE     ","C", 03,0})
AADD(aStru,{ "NUMERO    ","C", 06,0})
AADD(aStru,{ "ATENUMERO ","C", 06,0})
AADD(aStru,{ "CFO       ","C", 05,0})
AADD(aStru,{ "VALCONT   ","C", 12,0})
AADD(aStru,{ "BASEICMS1 ","C", 12,0})
AADD(aStru,{ "ALIQICMS1 ","C", 02,0})
AADD(aStru,{ "ICMS1     ","C", 12,0})
AADD(aStru,{ "ISENTOICM1","C", 12,0})
AADD(aStru,{ "DTENTRADA","C", 04,0})
AADD(aStru,{ "DIAINTEGRA","C", 02,0})
AADD(aStru,{ "VAGO01    ","C", 02,0})
AADD(aStru,{ "OUTRASICM1","C", 12,0})
AADD(aStru,{ "BASEIPI   ","C", 12,0})
AADD(aStru,{ "IPI       ","C", 12,0})
AADD(aStru,{ "ISENTOIPI ","C", 12,0})
AADD(aStru,{ "OUTRASIPI ","C", 12,0})
AADD(aStru,{ "TIPONF    ","C", 02,0})
AADD(aStru,{ "CODCONTAB ","C", 02,0})
AADD(aStru,{ "OBS       ","C", 14,0})
AADD(aStru,{ "UF        ","C", 02,0})
AADD(aStru,{ "CGC       ","C", 14,0})
AADD(aStru,{ "INSCR     ","C", 16,0})
AADD(aStru,{ "RAZAOSOC  ","C", 35,0})
AADD(aStru,{ "DESCONTO  ","C", 12,0})
AADD(aStru,{ "ESPECIE   ","C", 03,0})
AADD(aStru,{ "IPINAO    ","C", 12,0})
AADD(aStru,{ "VALORVISTA","C", 12,0})
AADD(aStru,{ "VAGO02    ","C", 08,0})
AADD(aStru,{ "ICMSFONTE ","C", 12,0})
AADD(aStru,{ "NUMMUNIC  ","C", 04,0})
AADD(aStru,{ "CTAFORN   ","C", 18,0})
AADD(aStru,{ "CONTRIB   ","C", 01,0})
AADD(aStru,{ "VALORPRAZO","C", 11,0})

//cArqTrab := CriaTrab(aStru, .T.)
//USE &cArqTrab ALIAS TRB NEW

cArqLOG := CriaTrab(aStru,.T.)
cIndLOG := "EMISSAO+SERIE+NUMERO"
dbUseArea(.T.,,cArqLOG,"TRB",.F.,.F.)

dbselectarea("SF3")
dbSetOrder(1)
dbSeek(xFilial("SF3")+DTOS(MV_PAR01),.T.)

ProcRegua(Reccount())

While !eof() .And. !_lFim .And. SF3->F3_ENTRADA <= MV_PAR02
	
	IncProc("Processando:"+DTOC(SF3->F3_ENTRADA))
	
	If subs(SF3->F3_CFO,1,1) < "5"
		dbselectarea("SF3")
		dbskip()
		loop
	Endif
	
	If !SF3->F3_tipo $ "DB"
		dbselectarea("SA1")
		dbSetOrder(1)
		dbseek(xfilial("SA1")+SF3->F3_CLIEFOR+SF3->F3_LOJA)
		cCGC    := SA1->A1_CGC
		cINSCR  := SA1->A1_INSCR
		cRAZAO  := SA1->A1_NOME
		cCONTA  := SA1->A1_CONTA
	Else
		dbselectarea("SA2")
		dbSetOrder(1)
		dbseek(xfilial("SA2")+SF3->F3_CLIEFOR+SF3->F3_LOJA)
		cCGC    := SA2->A2_CGC
		cINSCR  := SA2->A2_INSCR
		cRAZAO  := SA2->A2_NOME
		cCONTA  := SA2->A2_CONTA
	Endif
	
	dbselectarea("TRB")
	Reclock("TRB",.t.)
	TRB->EMISSAO   := subs(dtos(SF3->F3_EMISSAO),7,2)+subs(dtos(SF3->F3_EMISSAO),5,2)
	TRB->SERIE     := SF3->F3_serie
	TRB->NUMERO    := StrZero(Val(SF3->F3_NFISCAL),6)
	TRB->ATENUMERO := StrZero(Val(SF3->F3_NFISCAL),6)
	TRB->CFO       := SF3->F3_CFO
	TRB->VALCONT   := Strzero((SF3->F3_VALCONT*100),12)
	TRB->BASEICMS1 := Strzero((SF3->F3_BASEICM*100),12)
	TRB->ALIQICMS1 := Strzero((SF3->F3_ALIQICM*10000),6)
	TRB->ICMS1     := Strzero((SF3->F3_VALICM*100),12)
	TRB->ISENTOICM1:= Strzero((SF3->F3_ISENICM*100),12)
	TRB->DTENTRADA := subs(dtos(SF3->F3_ENTRADA),7,2)+subs(dtos(SF3->F3_ENTRADA),5,2)
	TRB->DIAINTEGRA:= Strzero(day(ddatabase),2)
	TRB->VAGO01    := Space(02)
	TRB->OUTRASICM1:= Strzero((SF3->F3_OUTRICM*100),12)
	TRB->BASEIPI   := Strzero((SF3->F3_BASEIPI*100),12)
	TRB->IPI       := Strzero((SF3->F3_VALIPI*100),12)
	TRB->ISENTOIPI := Strzero((SF3->F3_ISENIPI*100),12)
	TRB->OUTRASIPI := Strzero((SF3->F3_OUTRIPI*100),12)
	If !EMPTY(SF3->F3_DTCANC)
		TRB->TIPONF  := "99"
	ELSE
		TRB->TIPONF  := "00"
	ENDIF
	TRB->CODCONTAB := "00"
	TRB->OBS       := SF3->F3_OBSERV
	TRB->UF        := SF3->F3_ESTADO
	TRB->CGC       := cCGC
	TRB->INSCR     := cINSCR
	TRB->RAZAOSOC  := cRAZAO
	TRB->DESCONTO  := STRZERO(0,12)
	TRB->ESPECIE   := SF3->F3_ESPECIE
	TRB->IPINAO    := Strzero((SF3->F3_IPIOBS*100),12)
	TRB->VALORVISTA:= Strzero((SF3->F3_VALCONT*100),12)
	TRB->VAGO02    := Space(02)
	TRB->ICMSFONTE := Strzero((SF3->F3_ICMSRET*100),12)
	TRB->NUMMUNIC  := "0000"
	TRB->CTAFORN   := cCONTA
	IF EMPTY(cINSCR)
		TRB->CONTRIB   := "1"
	Else
		TRB->CONTRIB   := "0"
	ENDIF
	TRB->VALORPRAZO:= Strzero((SF3->F3_VALCONT*100),12)
	MsUnlock()
	
	dbselectarea("SF3")
	dbSkip()
EndDo

dbselectarea("TRB")
COPY TO &_cNomArqS SDF

dbclosearea("TRB")

dbselectarea("SF3")

Return
