#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Rotina   ³ PA0196   ³ Autor ³ Fabiano da Silva a    ³ Data ³ 28.10/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Exporta Livro Fiscal Entrada / Saida                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            Conforme e-mail Leandro - COAN (Contmatic)                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PA0196()
                                 
_nOpc := 0
@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Exportacao do Livro Fiscal")
@ 02,10 TO 080,220
@ 10,18 SAY "Rotina criada para exportacao dos dados do Livro  "    SIZE 160,7
@ 18,18 SAY "Fiscal para Escrituraçao do Livro Fiscal          "    SIZE 160,7
@ 26,18 SAY "Arquivo Exportado em F:\PROTHEUS11\PROTHEUS_DATA\Fiscal\"    SIZE 160,7
@ 34,18 SAY "com o nome PASY.??? . Programa PA0196.PRW         "    SIZE 160,7

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
Private _bAcao01   := {|_lFim| PA196A(@_lFim) }
Private _cTitulo01 := 'Processando'

Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )


Return


Static Function PA196A(_lFim)


_cNomArqE  := "\FISCAL\PASY_E.N"+STRZERO(MONTH(MV_PAR01),2)
_cNomArqS  := "\FISCAL\PASY_S.N"+STRZERO(MONTH(MV_PAR01),2)

VerEntr(_lFim)
VerSaid(_lFim)

Return


Static Function VerEntr(_lFim)

aStru := {}
AADD(aStru,{ "TPREG     ","C", 02,0})
AADD(aStru,{ "INDIC     ","C", 01,0})
AADD(aStru,{ "EMISSAO   ","C", 04,0})
AADD(aStru,{ "DTCIRCUL  ","C", 04,0})
AADD(aStru,{ "ESPECIE   ","C", 03,0})
AADD(aStru,{ "SERIE     ","C", 03,0})
AADD(aStru,{ "NUMERO    ","C", 06,0})
AADD(aStru,{ "ATENUMERO ","C", 06,0})
AADD(aStru,{ "UF        ","C", 02,0})
AADD(aStru,{ "CFO       ","C", 05,0})
AADD(aStru,{ "CODCONT   ","C", 03,0})
AADD(aStru,{ "GINTER    ","C", 01,0})
AADD(aStru,{ "CODMUN    ","C", 04,0})
AADD(aStru,{ "OBS       ","C", 14,0})
AADD(aStru,{ "VALCONT   ","C", 12,0})
AADD(aStru,{ "BASEICMS1 ","C", 12,0})
AADD(aStru,{ "ALIQICMS1 ","C", 02,0})
AADD(aStru,{ "ICMS1     ","C", 12,0})
AADD(aStru,{ "ISENTOICM1","C", 12,0})
AADD(aStru,{ "OUTRASICM1","C", 12,0})
AADD(aStru,{ "TIPONF1   ","C", 02,0})
AADD(aStru,{ "BASEICMS2 ","C", 12,0})
AADD(aStru,{ "ALIQICMS2 ","C", 02,0})
AADD(aStru,{ "ICMS2     ","C", 12,0})
AADD(aStru,{ "ISENTOICM2","C", 12,0})
AADD(aStru,{ "OUTRASICM2","C", 12,0})
AADD(aStru,{ "TIPONF2   ","C", 02,0})
AADD(aStru,{ "BASEICMS3 ","C", 12,0})
AADD(aStru,{ "ALIQICMS3 ","C", 02,0})
AADD(aStru,{ "ICMS3     ","C", 12,0})
AADD(aStru,{ "ISENTOICM3","C", 12,0})
AADD(aStru,{ "OUTRASICM3","C", 12,0})
AADD(aStru,{ "TIPONF3   ","C", 02,0})
AADD(aStru,{ "BASEICMS4 ","C", 12,0})
AADD(aStru,{ "ALIQICMS4 ","C", 02,0})
AADD(aStru,{ "ICMS4     ","C", 12,0})
AADD(aStru,{ "ISENTOICM4","C", 12,0})
AADD(aStru,{ "OUTRASICM4","C", 12,0})
AADD(aStru,{ "TIPONF4   ","C", 02,0})
AADD(aStru,{ "BASEICMS5 ","C", 12,0})
AADD(aStru,{ "ALIQICMS5 ","C", 02,0})
AADD(aStru,{ "ICMS5     ","C", 12,0})
AADD(aStru,{ "ISENTOICM5","C", 12,0})
AADD(aStru,{ "OUTRASICM5","C", 12,0})
AADD(aStru,{ "TIPONF5   ","C", 02,0})
AADD(aStru,{ "BASEIPI   ","C", 12,0})
AADD(aStru,{ "IPI       ","C", 12,0})
AADD(aStru,{ "ISENTOIPI ","C", 12,0})
AADD(aStru,{ "OUTRASIPI ","C", 12,0})
AADD(aStru,{ "IPINAPROV ","C", 12,0})
AADD(aStru,{ "BASEICMST ","C", 12,0})
AADD(aStru,{ "ICMSFONTE ","C", 12,0})
AADD(aStru,{ "PVV       ","C", 12,0})
AADD(aStru,{ "DESCONTO  ","C", 12,0})
AADD(aStru,{ "ABATIMEN  ","C", 12,0})
AADD(aStru,{ "VALORVISTA","C", 12,0})
AADD(aStru,{ "VALORPRAZO","C", 12,0})
AADD(aStru,{ "VENCTO    ","C", 05,0})
AADD(aStru,{ "ISENPISCOF","C", 12,0})
AADD(aStru,{ "CGC       ","C", 14,0})
AADD(aStru,{ "INSCR_EST ","C", 16,0})
AADD(aStru,{ "INSCR_MUN ","C", 10,0})
AADD(aStru,{ "RAZAOSOC  ","C", 35,0})
AADD(aStru,{ "ENDERECO  ","C", 50,0})
AADD(aStru,{ "NRENDER   ","C", 06,0})
AADD(aStru,{ "COMPLEMEN ","C", 25,0})
AADD(aStru,{ "BAIRRO    ","C", 40,0})
AADD(aStru,{ "CEP       ","C", 08,0})
AADD(aStru,{ "CODMUNDIPJ","C", 05,0})
AADD(aStru,{ "CIDADE    ","C", 40,0})
AADD(aStru,{ "UF_PART   ","C", 02,0})
AADD(aStru,{ "PAIS_PART ","C", 05,0})
AADD(aStru,{ "INSC_SUFR ","C", 09,0})
AADD(aStru,{ "CTAFORN   ","C", 18,0})

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
		cINSCM  := SA1->A1_INSCRM
		cRAZAO  := SA1->A1_NOME
		cCONTA  := SA1->A1_CONTA
		cENDER  := SA1->A1_END
		cNUMER  := SPACE(6)
		cCOMPL  := SA1->A1_COMPLEM
		cBAIRR  := SA1->A1_BAIRRO + SPACE(10)
		cCEP    := SA1->A1_CEP
		cCODMU  := SA1->A1_COD_MUN
		cCIDAD  := SA1->A1_MUN
		cUF_PA  := SA1->A1_EST
		cPAIS   := SA1->A1_PAIS + SPACE(2)
		cINSUF  := SA1->A1_SUFRAMA
	Else
		dbselectarea("SA2")
		dbSetOrder(1)
		dbseek(xfilial("SA2")+SF3->F3_CLIEFOR+SF3->F3_LOJA)
		cCGC    := SA2->A2_CGC
		cINSCR  := SA2->A2_INSCR
		cINSCM  := SA2->A2_INSCRM
		cRAZAO  := SA2->A2_NOME
		cCONTA  := SA2->A2_CONTA
		cENDER  := SA2->A2_END + Space(10)
		cNUMER  := SPACE(6)
		cCOMPL  := SA2->A2_COMPLEM
		cBAIRR  := SA2->A2_BAIRRO + SPACE(20)
		cCEP    := SA2->A2_CEP
		cCODMU  := SA2->A2_COD_MUN
		cCIDAD  := SA2->A2_MUN
		cUF_PA  := SA2->A2_EST
		cPAIS   := SA2->A2_PAIS + SPACE(2)
		cINSUF  := SPACE(9)
	Endif
	
	dbselectarea("TRB")
	Reclock("TRB",.t.)
	TRB->TPREG     := "R1"
	TRB->INDIC     := "E"
	TRB->EMISSAO   := subs(dtos(SF3->F3_ENTRADA),7,2)+subs(dtos(SF3->F3_ENTRADA),5,2)
	TRB->DTCIRCUL  := subs(dtos(SF3->F3_EMISSAO),7,2)+subs(dtos(SF3->F3_EMISSAO),5,2)
	TRB->ESPECIE   := SF3->F3_ESPECIE
	TRB->SERIE     := SF3->F3_SERIE
	TRB->NUMERO    := StrZero(Val(SF3->F3_NFISCAL),6)
	TRB->ATENUMERO := StrZero(Val(SF3->F3_NFISCAL),6)
	TRB->UF        := SF3->F3_ESTADO
	TRB->CFO       := SF3->F3_CFO
	TRB->CODCONT   := "001"
	IF EMPTY(cINSCR) .And. SF3->F3_CFO = '1949'
		TRB->GINTER    := "1"
	Else
		TRB->GINTER    := "0"
	ENDIF	
	TRB->CODMUN    := "0000"
	TRB->OBS       := SF3->F3_OBSERV
	TRB->VALCONT   := Strzero((SF3->F3_VALCONT*100),12)
	TRB->BASEICMS1 := Strzero((SF3->F3_BASEICM*100),12)
	TRB->ALIQICMS1 := Strzero((SF3->F3_ALIQICM*10000),6)
	TRB->ICMS1     := Strzero((SF3->F3_VALICM*100),12)
	TRB->ISENTOICM1:= Strzero((SF3->F3_ISENICM*100),12)
	TRB->OUTRASICM1:= Strzero((SF3->F3_OUTRICM*100),12)
	If !EMPTY(SF3->F3_DTCANC)
		TRB->TIPONF1  := "99"
	ELSE
		TRB->TIPONF1  := "00"
	ENDIF
	TRB->BASEICMS2 := STRZERO(0,12)
	TRB->ALIQICMS2 := STRZERO(0,6)
	TRB->ICMS2     := STRZERO(0,12)
	TRB->ISENTOICM2:= STRZERO(0,12)
	TRB->OUTRASICM2:= STRZERO(0,12)
	If !EMPTY(SF3->F3_DTCANC)
		TRB->TIPONF2  := "99"
	ELSE
		TRB->TIPONF2  := "00"
	ENDIF
	TRB->BASEICMS3 := STRZERO(0,12)
	TRB->ALIQICMS3 := STRZERO(0,6)
	TRB->ICMS3     := STRZERO(0,12)
	TRB->ISENTOICM3:= STRZERO(0,12)
	TRB->OUTRASICM3:= STRZERO(0,12)
	If !EMPTY(SF3->F3_DTCANC)
		TRB->TIPONF3  := "99"
	ELSE
		TRB->TIPONF3  := "00"
	ENDIF
	TRB->BASEICMS4 := STRZERO(0,12)
	TRB->ALIQICMS4 := STRZERO(0,6)
	TRB->ICMS4     := STRZERO(0,12)
	TRB->ISENTOICM4:= STRZERO(0,12)
	TRB->OUTRASICM4:= STRZERO(0,12)
	If !EMPTY(SF3->F3_DTCANC)
		TRB->TIPONF4  := "99"
	ELSE
		TRB->TIPONF4  := "00"
	ENDIF
	TRB->BASEICMS5 := STRZERO(0,12)
	TRB->ALIQICMS5 := STRZERO(0,6)
	TRB->ICMS5     := STRZERO(0,12)
	TRB->ISENTOICM5:= STRZERO(0,12)
	TRB->OUTRASICM5:= STRZERO(0,12)
	If !EMPTY(SF3->F3_DTCANC)
		TRB->TIPONF5  := "99"
	ELSE
		TRB->TIPONF5  := "00"
	ENDIF
	TRB->BASEIPI   := Strzero((SF3->F3_BASEIPI*100),12)
	TRB->IPI       := Strzero((SF3->F3_VALIPI*100),12)
	TRB->ISENTOIPI := Strzero((SF3->F3_ISENIPI*100),12)
	TRB->OUTRASIPI := Strzero((SF3->F3_OUTRIPI*100),12)
	TRB->IPINAPROV := Strzero((SF3->F3_IPIOBS*100),12)
	TRB->BASEICMST := Strzero((SF3->F3_BASERET*100),12)
	TRB->ICMSFONTE := Strzero((SF3->F3_ICMSRET*100),12)
	TRB->PVV       := STRZERO(0,12)
	TRB->DESCONTO  := STRZERO(0,12)
	TRB->ABATIMEN  := STRZERO(0,12)
	TRB->VALORVISTA:= STRZERO(0,12)
	TRB->VALORPRAZO:= Strzero((SF3->F3_VALCONT*100),12)
	TRB->VENCTO    := "00000"
	TRB->ISENPISCOF:= STRZERO(0,12)
	TRB->CGC       := cCGC
	TRB->INSCR_EST := cINSCR
	TRB->INSCR_MUN  := cINSCM
	TRB->RAZAOSOC  := cRAZAO
	TRB->ENDERECO  := cENDER
	TRB->NRENDER   := cNUMER
	TRB->COMPLEMEN := cCOMPL
	TRB->BAIRRO    := cBAIRR
	TRB->CEP	   := cCEP
	TRB->CODMUNDIPJ:= cCODMU
	TRB->CIDADE    := cCIDAD
	TRB->UF_PART   := cUF_PA
	TRB->PAIS_PART := cPAIS
	TRB->INSC_SUFR := cINSUF
	TRB->CTAFORN   := cCONTA
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
AADD(aStru,{ "TPREG     ","C", 02,0})
AADD(aStru,{ "INDIC     ","C", 01,0})
AADD(aStru,{ "EMISSAO   ","C", 04,0})
AADD(aStru,{ "DTCIRCUL  ","C", 04,0})
AADD(aStru,{ "ESPECIE   ","C", 03,0})
AADD(aStru,{ "SERIE     ","C", 03,0})
AADD(aStru,{ "NUMERO    ","C", 06,0})
AADD(aStru,{ "ATENUMERO ","C", 06,0})
AADD(aStru,{ "UF        ","C", 02,0})
AADD(aStru,{ "CFO       ","C", 05,0})
AADD(aStru,{ "CODCONT   ","C", 03,0})
AADD(aStru,{ "GINTER    ","C", 01,0})
AADD(aStru,{ "CODMUN    ","C", 04,0})
AADD(aStru,{ "OBS       ","C", 14,0})
AADD(aStru,{ "VALCONT   ","C", 12,0})
AADD(aStru,{ "BASEICMS1 ","C", 12,0})
AADD(aStru,{ "ALIQICMS1 ","C", 02,0})
AADD(aStru,{ "ICMS1     ","C", 12,0})
AADD(aStru,{ "ISENTOICM1","C", 12,0})
AADD(aStru,{ "OUTRASICM1","C", 12,0})
AADD(aStru,{ "TIPONF1   ","C", 02,0})
AADD(aStru,{ "BASEICMS2 ","C", 12,0})
AADD(aStru,{ "ALIQICMS2 ","C", 02,0})
AADD(aStru,{ "ICMS2     ","C", 12,0})
AADD(aStru,{ "ISENTOICM2","C", 12,0})
AADD(aStru,{ "OUTRASICM2","C", 12,0})
AADD(aStru,{ "TIPONF2   ","C", 02,0})
AADD(aStru,{ "BASEICMS3 ","C", 12,0})
AADD(aStru,{ "ALIQICMS3 ","C", 02,0})
AADD(aStru,{ "ICMS3     ","C", 12,0})
AADD(aStru,{ "ISENTOICM3","C", 12,0})
AADD(aStru,{ "OUTRASICM3","C", 12,0})
AADD(aStru,{ "TIPONF3   ","C", 02,0})
AADD(aStru,{ "BASEICMS4 ","C", 12,0})
AADD(aStru,{ "ALIQICMS4 ","C", 02,0})
AADD(aStru,{ "ICMS4     ","C", 12,0})
AADD(aStru,{ "ISENTOICM4","C", 12,0})
AADD(aStru,{ "OUTRASICM4","C", 12,0})
AADD(aStru,{ "TIPONF4   ","C", 02,0})
AADD(aStru,{ "BASEICMS5 ","C", 12,0})
AADD(aStru,{ "ALIQICMS5 ","C", 02,0})
AADD(aStru,{ "ICMS5     ","C", 12,0})
AADD(aStru,{ "ISENTOICM5","C", 12,0})
AADD(aStru,{ "OUTRASICM5","C", 12,0})
AADD(aStru,{ "TIPONF5   ","C", 02,0})
AADD(aStru,{ "BASEIPI   ","C", 12,0})
AADD(aStru,{ "IPI       ","C", 12,0})
AADD(aStru,{ "ISENTOIPI ","C", 12,0})
AADD(aStru,{ "OUTRASIPI ","C", 12,0})
AADD(aStru,{ "IPINAPROV ","C", 12,0})
AADD(aStru,{ "BASEICMST ","C", 12,0})
AADD(aStru,{ "ICMSFONTE ","C", 12,0})
AADD(aStru,{ "PVV       ","C", 12,0})
AADD(aStru,{ "DESCONTO  ","C", 12,0})
AADD(aStru,{ "ABATIMEN  ","C", 12,0})
AADD(aStru,{ "VALORVISTA","C", 12,0})
AADD(aStru,{ "VALORPRAZO","C", 12,0})
AADD(aStru,{ "VENCTO    ","C", 05,0})
AADD(aStru,{ "ISENPISCOF","C", 12,0})
AADD(aStru,{ "CGC       ","C", 14,0})
AADD(aStru,{ "INSCR_EST ","C", 16,0})
AADD(aStru,{ "INSCR_MUN ","C", 10,0})
AADD(aStru,{ "RAZAOSOC  ","C", 35,0})
AADD(aStru,{ "ENDERECO  ","C", 50,0})
AADD(aStru,{ "NRENDER   ","C", 06,0})
AADD(aStru,{ "COMPLEMEN ","C", 25,0})
AADD(aStru,{ "BAIRRO    ","C", 40,0})
AADD(aStru,{ "CEP       ","C", 08,0})
AADD(aStru,{ "CODMUNDIPJ","C", 05,0})
AADD(aStru,{ "CIDADE    ","C", 40,0})
AADD(aStru,{ "UF_PART   ","C", 02,0})
AADD(aStru,{ "PAIS_PART ","C", 05,0})
AADD(aStru,{ "INSC_SUFR ","C", 09,0})
AADD(aStru,{ "CTAFORN   ","C", 18,0})

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
		cINSCM  := SA1->A1_INSCRM
		cRAZAO  := SA1->A1_NOME
		cCONTA  := SA1->A1_CONTA
		cENDER  := SA1->A1_END
		cNUMER  := SPACE(6)
		cCOMPL  := SA1->A1_COMPLEM
		cBAIRR  := SA1->A1_BAIRRO + SPACE(10)
		cCEP    := SA1->A1_CEP
		cCODMU  := SA1->A1_COD_MUN
		cCIDAD  := SA1->A1_MUN
		cUF_PA  := SA1->A1_EST
		cPAIS   := SA1->A1_PAIS + SPACE(2)
		cINSUF  := SA1->A1_SUFRAMA
	Else
		dbselectarea("SA2")
		dbSetOrder(1)
		dbseek(xfilial("SA2")+SF3->F3_CLIEFOR+SF3->F3_LOJA)
		cCGC    := SA2->A2_CGC
		cINSCR  := SA2->A2_INSCR
		cINSCM  := SA2->A2_INSCRM
		cRAZAO  := SA2->A2_NOME
		cCONTA  := SA2->A2_CONTA
		cENDER  := SA2->A2_END + Space(10)
		cNUMER  := SPACE(6)
		cCOMPL  := SA2->A2_COMPLEM
		cBAIRR  := SA2->A2_BAIRRO + SPACE(20)
		cCEP    := SA2->A2_CEP
		cCODMU  := SA2->A2_COD_MUN
		cCIDAD  := SA2->A2_MUN
		cUF_PA  := SA2->A2_EST
		cPAIS   := SA2->A2_PAIS + SPACE(2)
		cINSUF  := SPACE(9)
	Endif
	
	dbselectarea("TRB")
	Reclock("TRB",.t.)
	TRB->TPREG     := "R1"
	TRB->INDIC     := "S"
	TRB->EMISSAO   := subs(dtos(SF3->F3_ENTRADA),7,2)+subs(dtos(SF3->F3_ENTRADA),5,2)
	TRB->DTCIRCUL  := subs(dtos(SF3->F3_EMISSAO),7,2)+subs(dtos(SF3->F3_EMISSAO),5,2)
	TRB->ESPECIE   := SF3->F3_ESPECIE
	TRB->SERIE     := SF3->F3_SERIE
	TRB->NUMERO    := StrZero(Val(SF3->F3_NFISCAL),6)
	TRB->ATENUMERO := StrZero(Val(SF3->F3_NFISCAL),6)
	TRB->UF        := SF3->F3_ESTADO
	TRB->CFO       := SF3->F3_CFO
	TRB->CODCONT   := "001"
	IF EMPTY(cINSCR) .And. SF3->F3_CFO = '6949'
		TRB->GINTER    := "1"
	Else
		TRB->GINTER    := "0"
	ENDIF	
	TRB->CODMUN    := "0000"
	TRB->OBS       := SF3->F3_OBSERV
	TRB->VALCONT   := Strzero((SF3->F3_VALCONT*100),12)
	TRB->BASEICMS1 := Strzero((SF3->F3_BASEICM*100),12)
	TRB->ALIQICMS1 := Strzero((SF3->F3_ALIQICM*10000),6)
	TRB->ICMS1     := Strzero((SF3->F3_VALICM*100),12)
	TRB->ISENTOICM1:= Strzero((SF3->F3_ISENICM*100),12)
	TRB->OUTRASICM1:= Strzero((SF3->F3_OUTRICM*100),12)
	If !EMPTY(SF3->F3_DTCANC)
		TRB->TIPONF1  := "99"
	ELSE
		TRB->TIPONF1  := "00"
	ENDIF
	TRB->BASEICMS2 := STRZERO(0,12)
	TRB->ALIQICMS2 := STRZERO(0,6)
	TRB->ICMS2     := STRZERO(0,12)
	TRB->ISENTOICM2:= STRZERO(0,12)
	TRB->OUTRASICM2:= STRZERO(0,12)
	If !EMPTY(SF3->F3_DTCANC)
		TRB->TIPONF2  := "99"
	ELSE
		TRB->TIPONF2  := "00"
	ENDIF
	TRB->BASEICMS3 := STRZERO(0,12)
	TRB->ALIQICMS3 := STRZERO(0,6)
	TRB->ICMS3     := STRZERO(0,12)
	TRB->ISENTOICM3:= STRZERO(0,12)
	TRB->OUTRASICM3:= STRZERO(0,12)
	If !EMPTY(SF3->F3_DTCANC)
		TRB->TIPONF3  := "99"
	ELSE
		TRB->TIPONF3  := "00"
	ENDIF
	TRB->BASEICMS4 := STRZERO(0,12)
	TRB->ALIQICMS4 := STRZERO(0,6)
	TRB->ICMS4     := STRZERO(0,12)
	TRB->ISENTOICM4:= STRZERO(0,12)
	TRB->OUTRASICM4:= STRZERO(0,12)
	If !EMPTY(SF3->F3_DTCANC)
		TRB->TIPONF4  := "99"
	ELSE
		TRB->TIPONF4  := "00"
	ENDIF
	TRB->BASEICMS5 := STRZERO(0,12)
	TRB->ALIQICMS5 := STRZERO(0,6)
	TRB->ICMS5     := STRZERO(0,12)
	TRB->ISENTOICM5:= STRZERO(0,12)
	TRB->OUTRASICM5:= STRZERO(0,12)
	If !EMPTY(SF3->F3_DTCANC)
		TRB->TIPONF5  := "99"
	ELSE
		TRB->TIPONF5  := "00"
	ENDIF
	TRB->BASEIPI   := Strzero((SF3->F3_BASEIPI*100),12)
	TRB->IPI       := Strzero((SF3->F3_VALIPI*100),12)
	TRB->ISENTOIPI := Strzero((SF3->F3_ISENIPI*100),12)
	TRB->OUTRASIPI := Strzero((SF3->F3_OUTRIPI*100),12)
	TRB->IPINAPROV := Strzero((SF3->F3_IPIOBS*100),12)
	TRB->BASEICMST := Strzero((SF3->F3_BASERET*100),12)
	TRB->ICMSFONTE := Strzero((SF3->F3_ICMSRET*100),12)
	TRB->PVV       := STRZERO(0,12)
	TRB->DESCONTO  := STRZERO(0,12)
	TRB->ABATIMEN  := STRZERO(0,12)
	TRB->VALORVISTA:= STRZERO(0,12)
	TRB->VALORPRAZO:= Strzero((SF3->F3_VALCONT*100),12)
	TRB->VENCTO    := "00000"
	TRB->ISENPISCOF:= STRZERO(0,12)
	TRB->CGC       := cCGC
	TRB->INSCR_EST := cINSCR
	TRB->INSCR_MUN  := cINSCM
	TRB->RAZAOSOC  := cRAZAO
	TRB->ENDERECO  := cENDER
	TRB->NRENDER   := cNUMER
	TRB->COMPLEMEN := cCOMPL
	TRB->BAIRRO    := cBAIRR
	TRB->CEP	   := cCEP
	TRB->CODMUNDIPJ:= cCODMU
	TRB->CIDADE    := cCIDAD
	TRB->UF_PART   := cUF_PA
	TRB->PAIS_PART := cPAIS
	TRB->INSC_SUFR := cINSUF
	TRB->CTAFORN   := cCONTA
	MsUnlock()
	
	dbselectarea("SF3")
	dbSkip()
EndDo

dbselectarea("TRB")
COPY TO &_cNomArqS SDF

dbclosearea("TRB")

dbselectarea("SF3")

Return