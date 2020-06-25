#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ VN0017   ºAutor  ³ Alexandro da Silva º Data ³  14/08/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Exporta Dados p/ Auditoria                                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SigaCTB                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function VN0017()

ATUSX1()

_nOpc := 0
@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Rotina para Exportar Dados Para Auditoria ")
@ 02,10 TO 080,220
@ 10,18 SAY "Rotina para Exportar Dados Para Auditoria           "    SIZE 160,7
@ 18,18 SAY "Conforme Parametros Informados.                     "     SIZE 160,7
@ 26,18 SAY "                                                    "     SIZE 160,7
@ 34,18 SAY "Programa VN0017.PRW                                 "     SIZE 160,7

@ 85,128 BMPBUTTON TYPE 5 ACTION Pergunte("VN0017")
@ 85,158 BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())
@ 85,188 BMPBUTTON TYPE 2 ACTION oDlg:END()

Activate Dialog oDlg Centered

If _nOpc == 1
	Pergunte("VN0017",.F.)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ mv_par01 -> Data De                                                 ³
	//³ mv_par02 -> Data Ate                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	Private _cMsg01    := ''
	Private _lFim      := .F.
	Private _lAborta01 := .T.
	Private _bAcao01   := {|_lFim| MZ81_A(@_lFim) }
	Private _cTitulo01 := 'Gerando Movimentacao !!!!'
	Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
	
Endif

Return


Static Function MZ81_A(_lFim)

PROCREGUA(03)

IncProc()

aStru:= CT2->(dbStruct())

_cQ := " SELECT "
_cQ += " FILIAL = CASE CT2_EMPORI   WHEN '01' THEN 'IRO' END, "
//_cQ += "                            WHEN '10' THEN 'MZMO' "
//_cQ += "                            WHEN '11' THEN 'MZPA' "
//_cQ += "                            WHEN '20' THEN 'MZAB' "
//_cQ += "                            WHEN '30' THEN 'MZBA' "
//_cQ += "                            WHEN '40' THEN 'MZMN' END, "
_cQ += " LANCAMENTO=CASE CT2_ROTINA WHEN 'CTBA101' THEN 'MANUAL' "
_cQ += "                            WHEN 'CTBA102' THEN 'MANUAL' "
_cQ += "                            ELSE 'AUTOMATICO' END, "
_cQ += " DATA = CONVERT(DATE,CT2_DATA,103), "
_cQ += " CT2_DEBITO,CT2_CREDIT,CT2_CCD,CT2_CCC,CT2_DC,CT2_VALOR,CT2_MOEDLC,CT2_LOTE,CT2_SBLOTE,CT2_DOC,CT2_TPSALD,CT2_HIST,CT2_ORIGEM,CT2_ROTINA "
_cQ += " FROM "+RetSqlName("CT2")+" WHERE D_E_L_E_T_=''AND CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND CT2_TPSALD='1' AND CT2_MOEDLC='01' "

TCQUERY _cQ NEW ALIAS "ZZ"

For ni := 1 to Len(aStru)
	If aStru[ni,2] != 'C'
		TCSetField('ZZ', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
	Endif
Next

_cArq    := CriaTrab(NIL,.F.)
Copy To &_cArq

//_cArqNew := "\AUDITORIA\CT2POLI"+DTOS(MV_PAR01)+DTOS(MV_PAR02)+".DBF"                                   

_cArqNew := "\AUDITORIA\CT2_"+SM0->M0_CODIGO+Alltrim(SM0->M0_FILIAL)+DTOS(MV_PAR01)+DTOS(MV_PAR02)+".DBF"

dbSelectArea("ZZ")
COPY ALL TO &_cArqNew
dbCloseArea("ZZ")

_cDir:= "C:\TOTVS"

If !ExistDir( _cDir )
	If MakeDir( _cDir ) <> 0
		MsgAlert(  "Impossível criar diretorio ( "+_cDir+" ) " )
		Return
	EndIf
EndIf

CpyS2T( _cArqNew, "C:\TOTVS", .T. )

/*
IncProc()

_cQ := " SELECT "
_cQ += " FILIAL = CASE CT2_EMPORI WHEN '11' THEN 'MZPA' "
_cQ += "                         WHEN '30' THEN 'MZBA'END, "
_cQ += " LANCAMENTO=CASE CT2_ROTINA WHEN 'CTBA101' THEN 'MANUAL' "
_cQ += "                          WHEN 'CTBA102' THEN 'MANUAL' "
_cQ += "                          ELSE 'AUTOMATICO'END, "
_cQ += "DATA = CONVERT(DATE,CT2_DATA,103), "
_cQ += "CT2_DEBITO,CT2_CREDIT,CT2_CCD,CT2_CCC,CT2_DC,CT2_VALOR,CT2_MOEDLC,CT2_LOTE,CT2_SBLOTE,CT2_DOC,CT2_TPSALD,CT2_HIST,CT2_ORIGEM,CT2_ROTINA "
_cQ += "FROM CT2910 "
_cQ += "WHERE D_E_L_E_T_=''AND CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND CT2_TPSALD='1' AND CT2_MOEDLC='01' "

TCQUERY _cQ NEW ALIAS "ZZ"

For ni := 1 to Len(aStru)
If aStru[ni,2] != 'C'
TCSetField('ZZ', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
Endif
Next

_cArq    := CriaTrab(NIL,.F.)
Copy To &_cArq

_cArqNew := "\AUDITORIA\CT2MARE"+DTOS(MV_PAR01)+DTOS(MV_PAR02)+".DBF"

dbSelectArea("ZZ")
COPY ALL TO &_cArqNew

dbCloseArea("ZZ")

IncProc()

_cQ := " SELECT "
_cQ += " FILIAL = CASE CT2_EMPORI  WHEN '01' THEN 'MZVI' "
_cQ += "                           WHEN '20' THEN 'MZAB'END,"
_cQ += "LANCAMENTO=CASE CT2_ROTINA WHEN 'CTBA101' THEN 'MANUAL' "
_cQ += "                           WHEN 'CTBA102' THEN 'MANUAL' "
_cQ += "                           ELSE 'AUTOMATICO'END, "
_cQ += "DATA = CONVERT(DATE,CT2_DATA,103), "
_cQ += "CT2_DEBITO,CT2_CREDIT,CT2_DC,CT2_VALOR,CT2_MOEDLC,CT2_LOTE,CT2_SBLOTE,CT2_DOC,CT2_TPSALD,CT2_HIST,CT2_ORIGEM,CT2_ROTINA "
_cQ += "FROM CT2900 "
_cQ += "WHERE D_E_L_E_T_=''AND CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND CT2_TPSALD='1' AND CT2_MOEDLC='01' "

TCQUERY _cQ NEW ALIAS "ZZ"

For ni := 1 to Len(aStru)
If aStru[ni,2] != 'C'
TCSetField('ZZ', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
Endif
Next

_cArq    := CriaTrab(NIL,.F.)
Copy To &_cArq
*/
//_cArqNew := "\AUDITORIA\CT2MZVI"+DTOS(MV_PAR01)+DTOS(MV_PAR02)+".DBF"

Return

Static Function ATUSX1()

cPerg := "VN0017"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ mv_par01 -> Data De                                                 ³
//³ mv_par02 -> Data Ate                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


//    	   Grupo/Ordem/Pergunta      /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid          /Var01     /Def01        /defspa1/defeng1/Cnt01/Var02/Def02               /Defspa2/defeng2/Cnt02/Var03/Def03  /defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
U_CRIASX1(cPerg,"01","Data De?      ",""       ,""      ,"mv_ch1","D" ,08     ,0      ,0     ,"G",""        ,"MV_PAR01","              ",""     ,""     ,""   ,""   ,"                 ",""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"")
U_CRIASX1(cPerg,"02","Data Ate?     ",""       ,""      ,"mv_ch2","D" ,08     ,0      ,0     ,"G",""        ,"MV_PAR02","              ",""     ,""     ,""   ,""   ,"                 ",""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"")

Return